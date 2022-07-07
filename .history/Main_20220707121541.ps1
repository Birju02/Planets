$Headers = @{"Authorization" = "Bearer 57a7e1d2-4b8c-47b7-aebd-f82f45402565" }        
 
$shipId = "cl562p2st33455915s67u6cryj8"
 
$destination = (Get-NearbyPlanet).symbol | Get-Random

$Metals = (Get-CurrentCargo -shipId $shipId | Where-Object { $_.good -eq "METALS" }).quantity


 
#Get Account details
function Get-AccountDetails {
     (Invoke-RestMethod -Headers $Headers -Method GET -Uri "https://api.spacetraders.io/my/account").user
}
 
 
# Funtion view available loans
function Get-AvailableLoans {
     (Invoke-RestMethod -Headers $Headers -Method GET -Uri "https://api.spacetraders.io/types/loans").loans
}

function New-Loan($Type) { 
    #   $Headers += @{"type"="STARTUP"}
    Invoke-RestMethod -Headers $Headers -Method POST -Uri "https://api.spacetraders.io/my/loans?type=$Type"
}

function Find-Loans {
     (Invoke-RestMethod -Headers $Headers -Method GET -Uri "https://api.spacetraders.io/my/loans").loans
}

function Get-ShipsAvailableToPurchase ($Class) {
     (Invoke-RestMethod -Headers $Headers -Method GET -Uri "https://api.spacetraders.io/systems/OE/ship-listings?class=$Class").shipListings
}

function New-Ship {
    # Parameter help description
    Param
 ([Parameter(Mandatory = $true)]
    [string]
    $location,
    # Parameter help description
    [Parameter(Mandatory = $true)]
    [string]
    $type
 )
    Invoke-RestMethod -Headers $Headers -Method POST -Uri "https://api.spacetraders.io/my/ships?type=$type&location=$location"
 
}

function Get-MyShips {
     (Invoke-RestMethod -Headers $Headers -Method GET -Uri "https://api.spacetraders.io/my/ships").ships
     
}


function Delete-Ship ($shipId) {
    Invoke-RestMethod -Headers $Headers -Method Delete -Uri "https://api.spacetraders.io/my/ships/$shipId"
}


function Get-ShipFuel {
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $shipId,
        # [Parameter(Mandatory = $true)]
        # [string]
        # $good,
        [Parameter(Mandatory = $true)]
        [string]
        $quantity
    )
    Invoke-RestMethod -Headers $Headers -Method POST -Uri "https://api.spacetraders.io/my/purchase-orders?shipId=$shipId&quantity=$quantity&good=FUEL"
}

function Get-MarketPlace {
     (Invoke-RestMethod -Headers $Headers -Method GET -Uri "https://api.spacetraders.io/locations/OE-PM-TR/marketplace").marketplace
}


function Get-Cargo {
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $shipId,
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $good,
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $quantity
    )
    Invoke-RestMethod -Headers $Headers -Method POST -Uri "https://api.spacetraders.io/my/purchase-orders?shipId=$shipId&good=$good&quantity=$quantity"
 
}


function Get-NearbyPlanet {
    ( Invoke-RestMethod -Headers $Headers -Method GET -Uri "https://api.spacetraders.io/systems/OE/locations?type=PLANET").locations
    
}

function Invoke-Travel {
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $shipId,
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $destination
    )

    $flightplan = (Invoke-RestMethod -Headers $Headers -Method POST -Uri "https://api.spacetraders.io/my/flight-plans?shipId=$shipId&destination=$destination").flightPlan
    Write-Output "Travel time is $($flightplan.timeRemainingInSeconds)"
    $ship = Get-ShipInfo -shipId $shipId
    while ($null -eq $ship.location) {
        Start-Sleep 5
        $ship = Get-ShipInfo -shipId $shipId
        Write-Output "Time remaining $((Get-FlightPlan -flightPlanId $ship.flightPlanId).timeRemainingInSeconds)"
    }
}

function Get-FlightPlan($flightPlanId) {
     
     (Invoke-RestMethod -Headers $Headers -Method GET -Uri "https://api.spacetraders.io/my/flight-plans/$flightPlanId").flightPlan
}



function Get-SellGoods {
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $shipId,
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $good,
        [Parameter(Mandatory = $true)]
        [string]
        $quantity
    )
    Invoke-RestMethod -Headers $Headers -Method POST -Uri "https://api.spacetraders.io/my/sell-orders?shipId=$shipId&good=$good&quantity=$quantity"
}

function Read-ViewAllAvailableGoods {
     (Invoke-RestMethod -Headers $Headers -Method GET -Uri "https://api.spacetraders.io/types/goods").goods
}

function Read-DockedShips ($systemSymbol) {
    Invoke-RestMethod -Headers $Headers -Method GET -Uri  https://api.spacetraders.io/systems/$systemSymbol/ship

}   
 

function Read-MarketPlaceInfo ($locationSymbol) {
   
   (Invoke-RestMethod -Headers $Headers -Method GET -Uri "https://api.spacetraders.io/locations/$locationSymbol/marketplace").marketplace
}

 
function Get-Cargo {
    param(
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $shipId,
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $good,
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $quantity
    )
    Invoke-RestMethod -Headers $Headers -Method POST -Uri  "https://api.spacetraders.io/my/purchase-orders?shipId=$shipId&good=$good&quantity=$quantity"
}



function New-Structure {
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $location,
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $type
    )
    Invoke-RestMethod -Headers $Headers -Method POST -Uri "https://api.spacetraders.io/my/structures?location=$location&type=$type"
}

# function GetSystemInfo {
#     Invoke-RestMethod -Headers $Headers -Method GET -Uri https://api.spacetraders.io/systems
 



function Get-WarpJump ($shipId) {
    Invoke-RestMethod -Headers $Headers -Method POST -Uri "https://api.spacetraders.io/my/warp-jumps?shipId=$shipId"
}



function Get-ShipInfo($shipId) {
     (Invoke-RestMethod -Headers $Headers -Method GET -Uri "https://api.spacetraders.io/my/ships/$shipId").ship
}


function Get-CurrentCargo($shipId) {
         
    return(Invoke-RestMethod -Headers $Headers -Method GET -Uri "https://api.spacetraders.io/my/ships/$shipId").ship.cargo
}     
 
 
function Get-FuelLevel {
    param(
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $shipId       
    )
    # Get-CurrentCargo -shipId $shipId |  Where-Object { $_.good -eq "FUEL" }.quantity 
    return (Get-CurrentCargo -shipId $shipId |  Where-Object { $_.good -eq "FUEL" }).quantity 
}

# $FuelLevel = ($ship.cargo | Where-Object { $_.good -eq "FUEL" }).quantity
 

function Add-JumpToRandomPlanet {
    param(
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $destination ,
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $shipId
    )
     (Invoke-RestMethod -Headers $Headers -Method POST -Uri "https://api.spacetraders.io/my/flight-plans?shipId=$shipId&destination=$destination").flightPlan
 
}




function Get-Fuel {
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $shipId,
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $quantity 
    )
    Invoke-RestMethod -Headers $Headers -Method POST -Uri "https://api.spacetraders.io/my/purchase-orders?shipId=$shipId&quantity=$quantity&good=FUEL"
}



function Start-Fuel ($shipId) {
    $FuelLevel = Get-FuelLevel -shipId $shipId
    if ( $FuelLevel -lt "15" ) {
        Get-Fuel -shipId $shipId  -quantity (15 - $FuelLevel) | Out-Null
        return "Purchased $(15 - $FuelLevel) fuel, your fuel is now 15"     
    }
    else {
        return "Fuel is already 15+"
    }
}
function Get-FuelLevel {
    param(
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $shipId       
    )
    # Get-CurrentCargo -shipId $shipId |  Where-Object { $_.good -eq "FUEL" }.quantity 
    return (Get-CurrentCargo -shipId $shipId |  Where-Object { $_.good -eq "FUEL" }).quantity 
}









function Start-METALS {

    $Metals = (Get-CurrentCargo -shipId $shipId | Where-Object { $_.good -eq "METALS" }).quantity
    if ($Metals -lt "5") {
  
        Get-Cargo -shipId $shipId  -quantity (5 - $Metals) | Out-Null
        return "Purchased $(5 - $Metals) metal"     
    }
    else {
        return "Metal is already 5+"
     }
    # elseif {
    #    "Metals do not exist on this planet"
    # }
    # return    
}




