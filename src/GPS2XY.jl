module GPS2XY

export gps_dist
export gps_bearing
export gps_offset
#export gps_sim
#export parse_log

# deprecated in Julia v0.6
#typealias LocTuple NTuple{2, Float64}
LocTuple  = NTuple{2, Float64}

"""
`gps_dist(latlon1::LocTuple, latlon2::LocTuple)`

Returns a scalar distance between these two points (I think it won't be -ve)
"""
function gps_dist(latlon1::LocTuple, latlon2::LocTuple)
	lat1 = latlon1[1]
	lon1 = latlon1[2]
	lat2 = latlon2[1]
	lon2 = latlon2[2]

	a = sind( (lat2-lat1)/2 )^2 + cosd(lat1)*cosd(lat2) * sind((lon2-lon1)/2)^2
	c = 2atan2(sqrt(a), sqrt(1-a))
	R = 6371000   # earth distance in meters
	d = R*c
	return d
end

"""
`gps_bearing(latlon1::LocTuple, latlon2::LocTuple)`

where `LocTuple` is a tuple of two floats.
Returns bearing from latlon1 to latlon2, east of north.
"""
function gps_bearing(latlon1::LocTuple, latlon2::LocTuple)
	lat1 = latlon1[1]
	lon1 = latlon1[2]
	lat2 = latlon2[1]
	lon2 = latlon2[2]


	y = sind(lon2-lon1)*cosd(lat2)
	x = cosd(lat1)*sind(lat2) - sind(lat1)*cosd(lat2)*cosd(lon2-lon1)
	return mod(rad2deg(atan2(y,x)), 360.0)
end

"""
`gps_offset(latlon1::LocTuple, latlon2::LocTuple)`

Returns the dx, dy offset from `latlon1` to `latlon2`.
"""
function gps_offset(latlon1::LocTuple, latlon2::LocTuple)
	d = gps_dist(latlon1, latlon2)
	b = gps_bearing(latlon1, latlon2)
	dx = d * sind(b)
	dy = d * cosd(b)
	return dx,dy
end


end # module
