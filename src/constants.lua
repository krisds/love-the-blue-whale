TITLE = "Löve, the Blue Whale"

WIDTH = 1000
HEIGHT = 500


STEPS_PER_DEGREE = 16
STEPS = 360 * STEPS_PER_DEGREE

SIN = {}
for i = 0, STEPS do
    SIN[i] = math.sin(math.rad(i/STEPS_PER_DEGREE))
end

