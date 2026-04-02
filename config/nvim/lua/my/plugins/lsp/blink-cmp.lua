local blink = {
  "saghen/blink.cmp",
  version = "1.*",
  event = "InsertEnter",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "default",
      ["<C-b>"] = { "scroll_documentation_up" },
      ["<C-f>"] = { "scroll_documentation_down" },
      ["<C-Space>"] = { "show" },
      ["<C-e>"] = { "cancel" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    },
    completion = {
      documentation = { auto_show = true },
      menu = {
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind" },
          },
        },
      },
    },
    sources = {
      default = { "lsp", "snippets", "path", "buffer" },
    },
    snippets = { preset = "default" },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}

return blink
