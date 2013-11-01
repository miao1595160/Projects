function [score] = AHP_Score_Negative(value)
if value >= 0
    if (value>= 0)&&(value < 0.2)
        score = 1;
    elseif (value>= 0.2)&&(value < 0.3)
        score = 1/2;
    elseif (value>= 0.3)&&(value < 0.4)
        score = 1/3;
    elseif (value>= 0.4)&&(value < 0.5)
        score = 1/4;
    elseif (value>= 0.5)&&(value < 0.6)
        score = 1/5;
    elseif (value>= 0.6)&&(value < 0.7)
        score = 1/6;
    elseif (value>= 0.7)&&(value < 0.8)
        score = 1/7;
    elseif (value>= 0.8)&&(value < 0.9)
        score = 1/8;
    else
        score = 1/9;
    end
else
    if (value<= 0)&&(value > -0.2)
        score = 1;
    elseif (value<= -0.2)&&(value > -0.3)
        score = 2;
    elseif (value<= -0.3)&&(value > -0.4)
        score = 3;
    elseif (value<= -0.4)&&(value > -0.5)
        score = 4;
    elseif (value<= -0.5)&&(value > -0.6)
        score = 5;
    elseif (value<= -0.6)&&(value > -0.7)
        score = 6;
    elseif (value<= -0.7)&&(value > -0.8)
        score = 7;
    elseif (value<= -0.8)&&(value > -0.9)
        score = 8;
    else
        score = 9;
    end
end
end
