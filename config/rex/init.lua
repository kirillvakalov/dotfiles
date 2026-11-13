-- Switch between panes with cmd+hjkl in Rex, to switch between windows in
-- paneru alt+hjkl keybinds are used
rex.bind('cmd+h', 'pane.focus.left')
rex.bind('cmd+j', 'pane.focus.down')
rex.bind('cmd+k', 'pane.focus.up')
rex.bind('cmd+l', 'pane.focus.right')

-- Default is cmd+k, which we use to switch to top pane
rex.bind('cmd+i', 'session.switch')
