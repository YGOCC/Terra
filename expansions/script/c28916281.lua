--This file was automatically coded by Kinny's Numeron Code~!
local id=28916281
local ref=_G['c'..id]
function ref.initial_effect(c)
	--Effect 0
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetRange(LOCATION_HAND)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetCondition(ref.sscon)
	e0:SetCost(ref.cost0)
	e0:SetTarget(ref.target0)
	e0:SetOperation(ref.operation0)
	c:RegisterEffect(e0)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1,id)
	--e1:SetCost(ref.reccost)
	e1:SetCondition(ref.reccon)
	e1:SetTarget(ref.target1)
	e1:SetOperation(ref.operation1)
	c:RegisterEffect(e1)
	--register to grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(ref.regcon)
	e3:SetOperation(ref.regop)
	c:RegisterEffect(e3)
end
function ref.ssfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function ref.tgfilter(c)
	return c:IsSetCard(0x747) and not (c:IsCode(id)) and c:IsAbleToGraveAsCost()
end
function ref.recfilter(c)
	return c:IsAbleToHand()
end
function ref.cfilter(c,p)
	return c:GetControler()==p and p==c:GetReasonPlayer() --rc:GetControler()
end
--Effect 0
function ref.sscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(ref.cfilter,1,nil,1-tp)
end
function ref.cost0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(ref.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,ref.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function ref.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return ref.ssfilter(e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function ref.operation0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (Duel.GetLocationCount(tp,LOCATION_MZONE)>0) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--Register
function ref.regcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) -- e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0) --and re:IsActiveType(TYPE_MONSTER) and (re:GetHandler():IsAttribute(ATTRIBUTE_LIGHT) or re:GetHandler():IsRace(RACE_BEAST))
end
function ref.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
--Effect 1
function ref.thcfilter(c)
	return c:IsSetCard(0x747) and c:IsAbleToRemoveAsCost()
end
function ref.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(ref.thcfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,ref.thcfilter,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function ref.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
end
function ref.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return ref.recfilter(e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,0)
end
function ref.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,tp,REASON_EFFECT)
	end
end