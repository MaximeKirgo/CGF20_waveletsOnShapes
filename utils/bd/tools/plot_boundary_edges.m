function plot_boundary_edges(N, bd, color, line_width)

if nargin<3
    color = [1 0 0];
end

if nargin<4
    line_width = 2;
end

for i=1:size(bd,1)
    p = N.VERT(bd(i,1),:);
    q = N.VERT(bd(i,2),:);
    plot3([p(1) q(1)], [p(2) q(2)], [p(3) q(3)], 'Color', color, 'LineWidth', line_width)
end

end
