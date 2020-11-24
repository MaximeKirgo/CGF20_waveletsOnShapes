function [W,Sc,Sl] = calc_LB_FEM(VERT,TRIV)

    n = size(VERT,1);
    m = size(TRIV,1);
% Stiffness (p.s.d.)

angles = zeros(m,3);
for i=1:3
    a = mod(i-1,3)+1;
    b = mod(i,3)+1;
    c = mod(i+1,3)+1;
    ab = VERT(TRIV(:,b),:) - VERT(TRIV(:,a),:);
    ac = VERT(TRIV(:,c),:) - VERT(TRIV(:,a),:);
    %normalize edges
    ab = ab ./ (sqrt(sum(ab.^2,2))*[1 1 1]);
    ac = ac ./ (sqrt(sum(ac.^2,2))*[1 1 1]);
    % normalize the vectors
    % compute cotan of angles
    angles(:,a) = cot(acos(sum(ab.*ac,2)));
    %cotan can also be computed by x/sqrt(1-x^2)
end

indicesI = [TRIV(:,1);TRIV(:,2);TRIV(:,3);TRIV(:,3);TRIV(:,2);TRIV(:,1)];
indicesJ = [TRIV(:,2);TRIV(:,3);TRIV(:,1);TRIV(:,2);TRIV(:,1);TRIV(:,3)];
values   = [angles(:,3);angles(:,1);angles(:,2);angles(:,1);angles(:,3);angles(:,2)]*0.5;
W = sparse(indicesI, indicesJ, -values, n, n);
W = W-sparse(1:n,1:n,sum(W));

% Mass

areas = calc_tri_areas_VERT_TRIV(VERT,TRIV);

indicesI = [TRIV(:,1);TRIV(:,2);TRIV(:,3);TRIV(:,3);TRIV(:,2);TRIV(:,1)];
indicesJ = [TRIV(:,2);TRIV(:,3);TRIV(:,1);TRIV(:,2);TRIV(:,1);TRIV(:,3)];
values   = [areas(:); areas(:); areas(:); areas(:); areas(:); areas(:)]./12;
Sc = sparse(indicesI, indicesJ, values, n, n);
Sc = Sc+sparse(1:n, 1:n, sum(Sc));

Sl = spdiag(sum(Sc,2));

end
