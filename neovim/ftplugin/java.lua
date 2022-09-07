local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- nvim-jdtls configs
local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), 'p:h:t')
local config = {
    cmd = {
              'java',
              '-Declipse.application=org.eclipse.jdt.ls.core.id1',
              '-Dosgi.bundles.defaultStartLevel=4',
              '-Declipse.product=org.eclipse.jdt.ls.core.product',
              '-Dlog.protocol=true',
              '-Dlog.level=ALL',
              '-Xms1g',
              '--add-modules=ALL-SYSTEM',
              '--add-opens', 'java.base/java.util=ALL-UNNAMED',
              '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
              '-jar', '/usr/local/Cellar/jdtls/1.15.0/libexec/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
              '-configuration', '/usr/local/Cellar/jdtls/1.15.0/libexec/config_mac',
              '-data', vim.fn.expand('~/.cache/jdtls-workspace') .. workspace_dir
        },

    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
    capabilities = capabilities
}
require('jdtls').start_or_attach(config)
