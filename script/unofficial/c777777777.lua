--Rule of the day: Terradivide V3
--At the start of the duel, each player places 1 Field Spell from their deck on the field
--The non turn player has their field face-down until the End Phase
--Field spells cannot leave the field by card effects (only by activating another field spell)
local s,id=GetID()
function s.initial_effect(c)
	aux.GlobalCheck(s,function()
		--place field
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_STARTUP)
		e1:SetTarget(s.target)
		e1:SetOperation(s.activate)
		Duel.RegisterEffect(e1,0)
		local e2=e1:Clone()
		Duel.RegisterEffect(e2,1)
		--Cannot leave the field or be affected
		local e3=Effect.CreateEffect(c)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_INDESTRUCTABLE)
		e3:SetTargetRange(LOCATION_FZONE,LOCATION_FZONE)
		e3:SetValue(1)
		Duel.RegisterEffect(e3,0)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CANNOT_REMOVE)
		Duel.RegisterEffect(e4,0)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_CANNOT_TO_GRAVE)
		Duel.RegisterEffect(e5,0)
		local e6=e3:Clone()
		e6:SetCode(EFFECT_CANNOT_TO_HAND)
		Duel.RegisterEffect(e6,0)
		local e7=e3:Clone()
		e7:SetCode(EFFECT_CANNOT_TO_DECK)
		Duel.RegisterEffect(e7,0)
		local ea=e3:Clone()
		Duel.RegisterEffect(ea,1)
		local eb=e4:Clone()
		Duel.RegisterEffect(eb,1)
		local ec=e5:Clone()
		Duel.RegisterEffect(ec,1)
		local ed=e6:Clone()
		Duel.RegisterEffect(ed,1)
		local ee=e7:Clone()
		Duel.RegisterEffect(ee,1)
	end)
end
function s.filter(c,tp)
	return c:IsType(TYPE_FIELD) and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp,true,true))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if Duel.IsTurnPlayer(tp) then
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEDOWN,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_FZONE,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_FZONE,0,nil)
	Duel.ChangePosition(g,POS_FACEUP)
end