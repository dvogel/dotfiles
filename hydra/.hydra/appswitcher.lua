ext.appswitcher = {}
ext.appswitcher.target_window = nil
ext.appswitcher.timer = timer.new(0.4)

function ext.appswitcher.nextwindow()
    local targetapp_title = nil
    local currentwin = window.focusedwindow()
    local currentapp = currentwin:application()
    local currentapp_title = currentapp:title()

    hydra.alert(currentapp_title)
    if currentapp_title == "MacVim" then targetapp_title = "iTerm"
    elseif currentapp_title == "iTerm" then targetapp_title = "Google Chrome"
    elseif currentapp_title == "Google Chrome" then targetapp_title = "MacVim"
    end
    hydra.alert(targetapp_title)

    if not (targetapp_title == nil) then
        for ix, win in pairs(window.orderedwindows()) do
            local win_app = win:application()
            local win_app_title = win_app:title()
            if win_app_title == targetapp_title then
                ext.appswitcher.target_window = win
                win:focus()
                break
            end
        end
    end

    if not (ext.appswitcher.target_window == nil) then
    end
end

