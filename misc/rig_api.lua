-- source code

local asset_service = game:GetService('AssetService')
local clear = table.clear
local get_bundle_details_async = asset_service.GetBundleDetailsAsync
local plrs = game:GetService('Players')
local plrs_ghdoid = plrs.GetHumanoidDescriptionFromOutfitId
local rig_type = Enum.HumanoidRigType

-- logic

_G.char = function(hd, name, rig, parent)
 if not hd then return end
 local char = plrs:CreateHumanoidModelFromDescription(hd, rig_type[rig or 'R15'])
 char.Archivable = true
 char.Name = name or 'Dummy'
 char.Parent = parent
 return char
end

_G.hd_from_bundle = function(id)
 if not id or id <= 0 then return end
 local succ, info = pcall(get_bundle_details_async, asset_service, id)
 if not succ or not info then return end
 local items = info.Items
 local len = #items
 if len <= 0 then return end
 local outfit_id = 0

 for idx = 1, len do
  local item = items[idx]
  if item.Type ~= 'UserOutfit' then continue end
  outfit_id = item.Id
  break
 end

 clear(items)
 if outfit_id <= 0 then return end
 local succ, hd = pcall(plrs_ghdoid, plrs, outfit_id)
 return succ and hd or nil
end

_G.rooms_scale = function(a)
 if not a then return a end

 if a:IsA('Humanoid') then
  a.BodyDepthScale.Value, a.BodyHeightScale.Value, a.BodyProportionScale.Value, a.BodyTypeScale.Value, a.BodyWidthScale.Value, a.HeadScale.Value = 0.9, 1, 0, 0, 1, 1
 elseif a:IsA('HumanoidDescription') then
  a.BodyTypeScale, a.DepthScale, a.HeadScale, a.HeightScale, a.ProportionScale, a.WidthScale = 0, 0.9, 1, 1, 0, 1
 end

 return a
end

_G.set_rt = function(a, b, ...)
 if not a then return a end

 if type(b) == 'string' then
  local args = {b, ...}
  for idx = 1, #args, 2 do a[args[idx]] = args[idx + 1] end
  clear(args)
 elseif type(b) == 'table' then for k, v in next, b do a[k] = v end end

 return a
end
