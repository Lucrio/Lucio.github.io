function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

@delay function hfun_list_tags()
    tagpages = globvar("fd_tag_pages")
    if tagpages === nothing
        return ""
    end
    tags = tagpages |> keys |> collect |> sort
    tags_num = length(tags)
    tags_count = [length(tagpages[t]) for t in tags]
    io = IOBuffer()
    write(io, """<div class="terms">""")
    write(io, """<p class="terms-title">Total Tags Number: $tags_num</p>""")
    for (t, c) in zip(tags, tags_count)
            write(io, """
              <a href=\"/tag/$t/\" class=\"tag-link\">$(replace(t, "_" => " "))<span class="tag-count"><sup>$c</sup></span></a>
            """)
    end
    write(io, """</div>""")
    return String(take!(io))
end

# doesn't need to be delayed because it's generated at tag generation,
# after everything else
function hfun_tag_list()
    tag = locvar(:fd_tag)::String
    items = Dict{Date,String}()
    for rpath in globvar("fd_tag_pages")[tag]
        title = pagevar(rpath, "title")
        # println(typeof(title))  #yf
        url = Franklin.get_url(rpath)
        surl = strip(url, '/')

        ys, ms, ps = split(surl, '/')[end-2:end]
        date = Date(parse(Int, ys), parse(Int, ms), parse(Int, first(ps, 2)))
        date_str = Dates.format(date, "Y-m-d")

        tmp = "* ~~~<span class=\"post-date tag\">$date_str</span><nobr><a class=\"blog-title-link\" href=\"$url\">$title</a></nobr>"
        descr = pagevar(rpath, :descr)
        if descr !== nothing
            tmp *= "<div class=\"post-descr\">$descr</div>"
        end
        tmp *= "~~~\n"
        items[date] = tmp
    end
    sorted_dates = sort!(items |> keys |> collect, rev=true)
    io = IOBuffer()
    write(io, """~~~<div class="franklin-content">~~~\n""")
    write(io, """~~~<div class="posts-container mx-auto px-3 py-5 list mb-5">~~~\n""")
    # write(io, "@@posts-container,mx-auto,px-3,py-5,list,mb-5\n")
    for date in sorted_dates
        write(io, items[date])
    end
    # write(io, "@@")
    write(io, """~~~</div>~~~""")
    write(io, """~~~</div>~~~""")
    return Franklin.fd2html(String(take!(io)), internal=true)
end


@delay function hfun_page_tags()
    pagetags = globvar("fd_page_tags")
    pagetags === nothing && return ""
    io = IOBuffer()
    tags = pagetags[splitext(locvar("fd_rpath"))[1]] |> collect |> sort
    write(io, """<div class="tags"> <em>tags: </em>""")
    for tag in tags[1:end-1]
        t = replace(tag, "_" => " ")
        write(io, """<a href="/tag/$tag/">$t</a>, """)
    end
    tag = tags[end]
    t = replace(tag, "_" => " ")
    write(io, """<a href="/tag/$tag/">$t</a></div>""")
    return String(take!(io))
end


function recent_in_dir(dir::String, date_var::String)
    list = readdir(dir)
    filter!(f -> endswith(f, ".md"), list)

    dates = [pagevar(joinpath(dir, f), date_var) for f in list]
    perm = sortperm(dates, rev=true)
    idxs = perm[1:min(3, length(perm))]
    io = IOBuffer()
    write(io, "<ul>")
    for i in idxs
        fi = joinpath("/"*dir, splitext(list[i]) |> first, "")
        fn = joinpath(dir, list[i])
        title = pagevar(fn, "title")
        date = dates[i]
        write(io, """<li> $date <a href="$fi">$title</a></li>\n""")
    end
    write(io, "</ul>")
    return String(take!(io))

end

hfun_recent_posts() = recent_in_dir("posts", "date")

hfun_recent_notes() = recent_in_dir("notes", "lastupdate")