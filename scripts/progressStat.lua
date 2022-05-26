local ProgressStat = {}
ProgressStat.Maximum = 100
ProgressStat.Minimum = 0
ProgressStat.Current = 50

function ProgressStat:Increase(amount)
    ProgressStat.Current = ProgressStat.Current + amount
end

function ProgressStat:Decrease(amount)
    ProgressStat.Current = ProgressStat.Current - amount
end

return ProgressStat