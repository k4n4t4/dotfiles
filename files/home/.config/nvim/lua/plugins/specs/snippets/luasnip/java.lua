local ls = require "luasnip"

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

return {
    ls.add_snippets("java", {
        s("servlet", {
            t({ "@WebServlet(\"/" }), i(1, "endpoint"), t({ "\")", "" }),
            t({ "public class " }), f(function() return vim.fn.expand("%:t:r") or "MyServlet" end), t({
            " extends HttpServlet {", "" }),
            t({
                "    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {",
                "" }),
            t({ "        " }), i(2), t({ "", "" }),
            t({ "    }", "", "" }),
            t({
                "    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {",
                "" }),
            t({ "        doGet(request, response);", "" }),
            t({ "    }", "" }),
            t({ "}" }),
        }),
    }),

    ls.add_snippets("java", {
        s("iservlet", {
            t({
                "import java.io.IOException;",
                "import java.io.PrintWriter;",
                "import javax.servlet.ServletException;",
                "import javax.servlet.annotation.WebServlet;",
                "import javax.servlet.http.HttpServlet;",
                "import javax.servlet.http.HttpServletRequest;",
                "import javax.servlet.http.HttpServletResponse;",
                ""
            })
        }),
    }),

    s("pwriter", {
        t("PrintWriter out = response.getWriter();"), i(0)
    }),

    s("getparam", {
        t("String "), i(1, "var"), t(" = request.getParameter(\""), i(2, "param"), t("\");"), i(0)
    }),

    s("forward", {
        t("request.getRequestDispatcher(\""), i(1, "/WEB-INF/jsp/index.jsp"), t("\").forward(request, response);"), i(0)
    }),

    s("setattr", {
        t("request.setAttribute(\""), i(1, "name"), t("\", "), i(2, "value"), t(");"), i(0)
    }),
}
