gen_op(CAT)

c  = @select CAT where Close;
cy = collapse(c, year, last)

# daily
Cd   = percentchange(c).values
GMMd = GMM(3, Cd, method=:kmeans, nInit=50, nIter=10)
MMd  = MixtureModel(GMMd)

#yearly
Cy   = percentchange(cy).values
GMMy = GMM(3, Cy, method=:kmeans, nInit=50, nIter=10)
MMy  = MixtureModel(GMMy)


function rday() 
    rand(MMd, 13089)
end

function ryear()  
    rand(MMy, 51)
end
