local hiscore = { _version = "0.1" }
local http = require("socket.http")

local json = require "json"

function hiscore.get_hiscores(n,mode)
    query = "?"
    if not (n == null) then
        query = query.."&top="..n
    end
    if not (mode == null) then
        query = query.."&mode="..mode
    end
    local body, code, headers, status = http.request("http://takenbymood.pythonanywhere.com/get-hiscores"..query)
    local obj = null
    if code == 200 then
        obj = json.decode(body)
    else
        print('hiscores are inaccessible!')
    end
    return obj
end

function hiscore.check_hiscore(score,mode)
    n = 10
    scores = hiscore.get_hiscores(n,mode)
    if scores == null then
        print('hiscores are inaccessible!')
        return false
    end
    has_hiscore = false
    count = 0
    for k,v in pairs(scores['score']) do
        count = count + 1
        if mode == 'classic' then
            if v < score then
                has_hiscore = true
            end
        else
            if v > score then
                has_hiscore = true
            end
        end
    end
    if count < n then
        -- the hiscores table is too short
        has_hiscore = true
    end
    return has_hiscore
end

function hiscore.post_hiscore(name,score,err,mode)
    local p_body, p_code, p_headers, p_status = http.request("http://takenbymood.pythonanywhere.com/post-hiscore?name="..name.."&err="..err.."&score="..score.."&mode="..mode)
    message = "could not post high score :("
    if p_code == 200 then
        message = "posted your highscore!"
    end
    return message
end

return hiscore