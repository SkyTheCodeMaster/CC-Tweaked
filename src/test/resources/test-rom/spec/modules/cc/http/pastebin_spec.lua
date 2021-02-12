local capture = require "test_helpers".capture_program

describe("The pastebin module", function()
    local pastebin = require("cc.http.pastebin")
    local function setup_request()
        stub(_G, "http", {
            checkURL = function()
                return true
            end,
            get = function()
                return {
                    readAll = function()
                        return "Test string!"
                    end,
                    close = function()
                    end,
                    getResponseHeaders = function()
                        local tHeader = {}
                        tHeader["Content-Type"] = "text/plain; charset=utf-8"
                        return tHeader
                    end,
                }
            end,
            post = function()
                return {
                    readAll = function()
                        return "https://pastebin.com/abcde"
                    end,
                    close = function()
                    end,
                }
            end,
        })
    end

    it("downloads one file", function()
        setup_request()
        local str
        capture(stub, str = pastebin.get("abcde"))

        expect(str):eq("Test string!")
    end)

    it("upload a program to pastebin", function()
        setup_request()

        local str = "Test string!"

        expect(capture(stub, pastebin.put(str)))
            :matches("abcde")
    end)

end)
