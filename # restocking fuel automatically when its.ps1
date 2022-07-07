# # restocking fuel automatically when its gets below 3
$ship = Get-ShipInfo -shipId $shipId


# 1 - Check fuel level, fill below below 5 by addng five
# 2 - Travel
# 3 - Compare price with other location
# 3 - Sell or buy
# 2 - fill fuel or end 
# 3 - Repeat


$CurrentLocation = (Invoke-RestMethod -Headers $Headers -Method GET -Uri "https://api.spacetraders.io/my/ships/$shipId").ship.location

$destination = (Get-NearbyPlanet).symbol | Get-Random 

Invoke-Travel -shipId $shipId -destination $destination

Start-Fuel -shipId $shipId 