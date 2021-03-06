local function googlethat(query)
  local api        = "http://ajax.googleapis.com/ajax/services/search/web?v=1.0&"
  local parameters = "q=".. (URL.escape(query) or "")

  -- Do the request
  local res, code = https.request(api..parameters)
  if code ~=200 then return nil  end
  local data = json:decode(res)

  local results = {}
  for key,result in ipairs(data.responseData.results) do
    table.insert(results, {
        result.titleNoFormatting,
        result.unescapedUrl or result.url
      })
  end
  return results
end

local function stringlinks(results)
  local stringresults=""
  for key,val in ipairs(results) do
    stringresults=stringresults..val[1].." - "..val[2].."\n"
  end
  return stringresults
end

local function run(msg, matches)
  local results = googlethat(matches[1])
  return stringlinks(results)
end

return {
  description = "Searches Google and send results",
  usage = "!google [terms]: Searches Google and send results",
  patterns = {
    "^[!/]google (.*)$",
     "^سرچ کن (.*)$",
  },
  run = run
