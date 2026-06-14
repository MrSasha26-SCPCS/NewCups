local GameObject = CS.UnityEngine.GameObject
local Vector3 = CS.UnityEngine.Vector3

---@class Cup:CS.Akequ.Items
Cup = {}

function Cup:PlaySound(go)
    local clip = CS.ResourcesManager.GetClip("slurp")
    local source = go:AddComponent(typeof(CS.UnityEngine.AudioSource))
    source.clip = clip
    source.volume = 0.85
    source.minDistance = 0
    source.maxDistance = 12
    source.spatialBlend = 1
    source.rolloffMode = CS.UnityEngine.AudioRolloffMode.Linear
    source:Play()
end

function Cup:GetWorldPrefab()
    return GameObject.Instantiate(CS.ResourcesManager.GetObject("item_w_cup"))
end

function Cup:OnUse()
    if self.main.player.isServer then    
        self.main:SendToEveryone("PlaySound", self.main.player.gameObject)
        self.main.player:RemoveItemOnServer(self.main)
        local netRooms = GameObject.FindObjectsOfType(typeof(CS.NetRoom))
        local random = math.random(0, netRooms.Length - 1)
        local netRoom = netRooms[random]
        local APTeleport = netRoom.roomObj.transform:Find("APTeleport")
        if APTeleport ~= nil then
            self.main.player:Teleport(APTeleport.transform.position + Vector3.up, netRoom)
        else
            self.main.player:Teleport(netRoom.roomObj.transform.position + Vector3.up, netRoom)
        end
    end
end

function Cup:GetName()
    return "Стаканчик"
end

function Cup:GetImage()
    return CS.ResourcesManager.GetSprite("inv_item_cup")
end

return Cup