--Silvermage of Summoning
function c249000174.initial_effect(c)
	--summon & set with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(249000174,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c249000174.ntcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75878039,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,249000174)
	e3:SetTarget(c249000174.target)
	e3:SetOperation(c249000174.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c249000174.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)<Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)
end
function c249000174.filter(c)
	return c:IsType(TYPE_SPELL) and bit.band(c:GetActivateEffect():GetCategory(),CATEGORY_SPECIAL_SUMMON)~=0 and c:IsAbleToHand()
end
function c249000174.filter2(c)
	return c:IsSetCard(0x163) and c:GetCode()~=249000174
end
function c249000174.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000174.filter,tp,LOCATION_DECK,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000174.filter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c249000174.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c249000174.filter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) then return end
	if not Duel.IsExistingMatchingCard(c249000174.filter2,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) then
		if Duel.IsExistingMatchingCard(c249000174.filter2,tp,LOCATION_HAND,0,1,nil) then
			local g=Duel.SelectMatchingCard(tp,c249000174.filter2,tp,LOCATION_HAND,0,1,1,nil)
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleHand(tp)
		else
			return
		end	
	end
	local g=Duel.SelectMatchingCard(tp,c249000174.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c249000174.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end
