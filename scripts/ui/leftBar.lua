local LeftBar = {}

LeftBar.Window = nil
LeftBar.Button = nil

LeftBar.IsExpanded = false

function LeftBar:AddWindow(window)
    self.Window = window
end

function LeftBar:AddButton(button)
    self.Button = button
end

function LeftBar:ChangeState()
    if self.IsExpanded then
        self:Collapse()
    else
        self:Expand()
    end
end

function LeftBar:Expand()
    self.Window:SetPosition(0, 300)
    self.Button:SetPosition(360, 260)
    self.Button.Text = "<<"
    self.IsExpanded = true
end

function LeftBar:Collapse()
    self.Window:SetPosition(-300, 300)
    self.Button:SetPosition(60, 260)
    self.Button.Text = ">>"
    self.IsExpanded = false
end

return LeftBar
