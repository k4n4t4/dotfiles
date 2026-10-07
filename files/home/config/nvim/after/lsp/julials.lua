return {
    cmd = {
        "julia",
        "--startup-file=no",
        "--history-file=no",
        "-e",
        [[
            using LanguageServer
            server = LanguageServer.LanguageServerInstance(
                stdin,
                stdout,
                dirname(Base.active_project())
            )
            run(server)
        ]],
    },
    filetypes = { "julia" },
}
