# Class diagram of a package for the documentation, in the Mermaid language.
# The loaded package supplies the diagram, thus the diagram always shows the current code.

# Values of the type `kind` that `mod` defines. A name that the compiler generates starts with `#`.
function definitions(mod, kind)
    found = Any[]
    for name in names(mod; all=true)
        isdefined(mod, name) && !startswith(string(name), '#') || continue
        value = getfield(mod, name)
        value isa kind && parentmodule(value) === mod && nameof(value) === name &&
            push!(found, value)
    end
    return found
end

# `mod`, then each module that `mod` contains, at each depth.
function submodules(mod)
    children = filter(child -> child !== mod, definitions(mod, Module))
    return [mod; mapreduce(submodules, vcat, children; init=Module[])]
end

# Submodule of `pkg`, at the first depth, that contains the type `T`.
function namespace(T, pkg)
    mod = parentmodule(T)
    while mod !== pkg && parentmodule(mod) !== pkg
        mod = parentmodule(mod)
    end
    return mod
end

# Names of the types of the package in `T`, the type of an argument or of a field.
function class_names(T, types)
    T isa TypeVar && return class_names(T.ub, types)
    T isa UnionAll && return class_names(Base.unwrap_unionall(T), types)
    T isa Union && return mapreduce(U -> class_names(U, types), vcat, Base.uniontypes(T))
    T isa DataType && Base.typename(T).wrapper in types && return [nameof(T)]
    return Symbol[]
end

# A field without a declared type has the type `Any`, which the diagram does not show.
# A brace closes a class in Mermaid, thus the label has the Mermaid mark for a parameter.
function field_label(name, T)
    T isa TypeVar && return field_label(name, T.ub)
    return T === Any ? string(name) : replace("$name::$T", r"[{}]" => "~")
end

"""
Return the Mermaid source of the class diagram of the package `pkg`.

Each type of the package is a class, in the namespace of its submodule. A class lists the
fields of the type, and the functions that have a method with the type as the first argument.
Only the functions that those submodules define are in the diagram.

The diagram has two relations. An arrow goes from a subtype to its supertype. If the package
defines the type of a field, a line joins the type that has the field to the type of the field.
"""
function class_diagram_source(pkg::Module)
    types = mapreduce(mod -> definitions(mod, Union{DataType,UnionAll}), vcat,
                      submodules(pkg))
    namespaces = unique(namespace(T, pkg) for T in types)
    functions = mapreduce(mod -> definitions(mod, Function), vcat, namespaces)

    members = Dict(nameof(T) => String[] for T in types)
    relations = String[]
    for T in types
        for parent in class_names(supertype(T), types)
            push!(relations, "$parent <|-- $(nameof(T))")
        end
        isabstracttype(T) && continue
        body = Base.unwrap_unionall(T)
        for (name, F) in zip(fieldnames(body), fieldtypes(body))
            push!(members[nameof(T)], field_label(name, F))
            for class in class_names(F, types)
                push!(relations, "$(nameof(T)) *-- $class : $name")
            end
        end
    end
    for f in functions, method in methods(f)
        arguments = Base.unwrap_unionall(method.sig).parameters
        length(arguments) > 1 || continue
        for class in class_names(arguments[2], types)
            push!(members[class], "$(nameof(f))()")
        end
    end

    # With this direction, Mermaid puts each namespace below the previous one.
    # A namespace without a relation to a different namespace is a tree from top to bottom.
    lines = ["classDiagram", "    direction LR"]
    for mod in namespaces
        push!(lines, "    namespace $(nameof(mod)) {")
        for T in filter(T -> namespace(T, pkg) === mod, types)
            body = unique(members[nameof(T)])
            isabstracttype(T) && pushfirst!(body, "<<abstract>>")
            push!(lines, "        class $(nameof(T)) {", ("            " .* body)...,
                  "        }")
        end
        push!(lines, "    }")
    end
    return join([lines; "    " .* relations], "\n")
end

"""
Return the class diagram of the package `pkg` as an HTML element that Mermaid draws.

When the page opens, the element loads Mermaid from a content delivery network.
"""
function class_diagram(pkg::Module)
    source = replace(class_diagram_source(pkg), "&" => "&amp;", "<" => "&lt;",
                     ">" => "&gt;")
    return HTML("""
                <div class="mermaid">
                $source
                </div>
                <script type="module">
                import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/+esm";
                mermaid.initialize({startOnLoad: true, theme: "neutral"});
                </script>
                """)
end
