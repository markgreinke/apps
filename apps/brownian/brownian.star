load("render.star", "render")
load("math.star", "math")
load("random.star", "random")

def main(config):
    # Initialize particles (x, y, vx, vy)
    particles = []
    for _ in range(20):
        particles.append([
            random.number(0, 63), 
            random.number(0, 31), 
            random.number(-1, 1), 
            random.number(-1, 1)
        ])

    frames = []
    for f in range(100):
        children = []
        
        # 1. Update particle positions
        for p in particles:
            p[0] += p[2]
            p[1] += p[3]
            
            # Wall bounces
            if p[0] < 0 or p[0] > 63: p[2] *= -1
            if p[1] < 0 or p[1] > 31: p[3] *= -1
            
            # Clamp to screen
            p[0] = math.max(0, math.min(63, p[0]))
            p[1] = math.max(0, math.min(31, p[1]))
            
            # Render particle
            children.append(render.Box(width=1, height=1, color="#fff"))
            
        # NOTE: The O(N^2) collision loop has been removed to improve 
        # performance and prevent Starlark execution timeouts.
        
        frames.append(render.Stack(children=children))
        
    return render.Root(
        delay=100, 
        child=render.Animation(children=frames)
    )