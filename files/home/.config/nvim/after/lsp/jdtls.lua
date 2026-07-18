return {
    cmd = {
        "jdtls",
        "-data",
        vim.fn.stdpath("cache") .. "/jdtls/workspace",
    },
    settings = {
        java = {
            project = {
                referencedLibraries = {},
            },
        },
    },
}
