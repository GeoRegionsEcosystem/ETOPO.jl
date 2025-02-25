### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ b00d1044-f2ff-11ef-24ea-5f1d9ca153fb
begin
	using Pkg; Pkg.activate()
	using DrWatson
end

# ╔═╡ 31bd1469-cd9a-48d2-bb09-e220f7ec70ed
begin
	using ETOPO
	using PyCall
	using ImageShow, PNGFiles

	uplt = pyimport("proplot")
end

# ╔═╡ 98345773-43d4-45cd-8ee0-1bf901f33652
lsd = getLandSea(ETOPODataset(),savelsd=true,returnlsd=true)

# ╔═╡ 45dcced2-258a-447b-9093-b7421743050f
begin
	for ilon = 1 : 359
		uplt.close()
		fig,axs = uplt.subplots(proj="ortho",proj_kw=Dict("lon_0"=>ilon),axwidth=1.5)
	
	
		axs[1].pcolormesh(lsd.lon[1:20:end],lsd.lat[1:20:end],lsd.z[1:20:end,1:20:end]'./1e3,levels=-6:6,extend="both",cmap="bukavu")
		axs[1].format(coast=true,grid=false)
		
		fig.savefig("etopologo-$ilon.png",transparent=true,dpi=96)
		# load("etopologo.png")
	end
end

# ╔═╡ Cell order:
# ╠═b00d1044-f2ff-11ef-24ea-5f1d9ca153fb
# ╠═31bd1469-cd9a-48d2-bb09-e220f7ec70ed
# ╠═98345773-43d4-45cd-8ee0-1bf901f33652
# ╠═45dcced2-258a-447b-9093-b7421743050f
