command! FixupAll :2,$s/^pick /fixup /g
command! SquashAll :2,$s/^pick /squash /g
nmap F :FixupAll<CR>
nmap S :SquashAll<CR>

