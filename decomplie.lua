local open_ai_url = "https://api.openai.com/v1/chat/completions";
local api_key = "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"
local http_service = cloneref(game:GetService("HttpService"));

local format = string.format;

local json_encode,json_decode = function(...)return http_service:JSONEncode(...)end,function(...)return http_service:JSONDecode(...)end;
local api = {}; do
    function get(url, ...)
        return request({Url=url,Method="GET"}).Body;
    end
    function post(...)
    	local post_args = ...;
        return request({
        	Url=open_ai_url,
        	Method="POST",
        	Headers={
        		["Content-Type"]=post_args.content_type,
        		["Authorization"]="Bearer "..post_args.authorization,
        	},
        	Body=json_encode(post_args.body),
        })
    end

    api.get = get;
    api.post = post;
end

loadstring(api.get("https://raw.githubusercontent.com/xZcAtliftz/Project-Secret/main/disassemble.lua"))()

print(disassemble)

function decompile(path)
    local res = post({
        content_type="application/json",
        authorization=api_key,
        body={
            ["model"]="gpt-3.5-turbo",
            ["messages"]={
                ["role"]="user",
                ["content"]=format("%s\n```lua\n%s\n```", "convert these luau instructions into readable luau code and simplify it.", disassemble(path))
            },
        }
    });
    
    local decoded_response = json_decode(res.Body);
    local real_res = (decoded_response.choices and decoded_response.choices.message.content or "failed to decompile");
	
    return real_res;
end
getgenv().decompile = decompile;
return decompile
