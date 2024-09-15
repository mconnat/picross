function DrawMapSelectionButtons()
    local buttonX = DisplayWidth - 150
    local buttonWidth = 130
    local buttonY = 40
    local buttonHeight = 30
    local menuText = "Select Grid"
    local font = love.graphics.getFont()
    local fontWidth = font:getWidth(menuText)
    local fontHeight = font:getHeight(menuText)
    love.graphics.print(menuText, buttonX + (buttonWidth / 2), buttonY - 20, 0, 1, 1, fontWidth / 2, fontHeight / 2)
    for index, btn in ipairs(SelectionGridButtons) do
        btn.X = buttonX
        btn.Width = buttonWidth
        btn.Y = buttonY * index
        btn.Height = buttonHeight
        btn:draw()
    end
end

function CheckMouseCollision(mouseX, mouseY)
    for i = 1, #SelectedGrid.Grid.GridInfo do
        local line = {}
        for j = 1, #SelectedGrid.Grid.GridInfo[i] do
            local case = SelectedGrid.Grid.GridInfo[i][j]
            if mouseX >= case.X and mouseX <= (case.X + case.Width) and mouseY >= case.Y and mouseY <= (case.Y + case.Height) then
                case:onClick()
            end
        end
    end
    for _, btn in ipairs(SelectionGridButtons) do
        if mouseX >= btn.X and mouseX <= (btn.X + btn.Width) and mouseY >= btn.Y and mouseY <= (btn.Y + btn.Height) then
            btn:onClick()
        end
    end
end

function CompteSeries(array)
    local result = {}
    local counter = 0
    for i = 1, #array do
        if array[i] == 1 then
            counter = counter + 1
        end
        if counter > 0 and array[i] == 0 then
            table.insert(result, counter)
            counter = 0
        end
    end
    if counter > 0 then
        table.insert(result, counter)
    end
    return result
end
