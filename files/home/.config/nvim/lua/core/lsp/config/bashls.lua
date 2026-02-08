return {
    cmd = { "bash-language-server", "start" };
    filetypes = { "sh", "bash" };
    settings = {
        bash = {
            enable = true;
            executionCommand = {};
            ignorePatterns = {};
            ignoreWarnings = {};
            excludePaths = {};
        };
    };
}
