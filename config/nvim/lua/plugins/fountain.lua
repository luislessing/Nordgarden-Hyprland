return {
  {
    "kblin/vim-fountain",
    ft = { "fountain" },
    init = function()
      vim.filetype.add({
        extension = {
          fountain = "fountain",
        },
      })
    end,
  },
}
