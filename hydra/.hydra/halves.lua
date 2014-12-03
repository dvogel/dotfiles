ext.halves = {}

local function frame_eql(a,b)
    return ((a.x == b.x)
            and (a.y == b.y)
            and (a.w == b.w)
            and (a.h == b.h))
end

local function screen_rect()
  local win = window.focusedwindow()
  local newframe = win:screen():frame_without_dock_or_menu()
  return newframe
end

function ext.halves.left_dimensions()
    local s = screen_rect()
    return {
        x = s.x,
        y = s.y,
        w = math.floor(s.w / 2),
        h = s.h
    }
end

function ext.halves.right_dimensions()
    local s = screen_rect()
    return {
        x = s.x + math.floor(s.w / 2),
        y = s.y,
        w = math.floor(s.w / 2),
        h = s.h
    }
end

function ext.halves.is_left(win)
    return frame_eql(win:frame(), ext.halves.left_dimensions())
end

function ext.halves.is_right(win)
    return frame_eql(win:frame(), ext.halves.right_dimensions())
end

function ext.halves.window_left()
    local win = window.focusedwindow()
    if ext.halves.is_left(win) == true then
        ext.halves.window_maximize()
    else
        win:setframe(ext.halves.left_dimensions())
    end
end

function ext.halves.window_right()
    local win = window.focusedwindow()
    if ext.halves.is_right(win) == true then
        ext.halves.window_maximize()
    else
        win:setframe(ext.halves.right_dimensions())
    end
end

function ext.halves.window_maximize()
    window.focusedwindow():setframe(screen_rect())
end

