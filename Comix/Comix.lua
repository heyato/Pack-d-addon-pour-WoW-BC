function Comix_OnLoad()

-- Registering Events --

this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

this:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF")
this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS")
this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE")
this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
this:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS")
this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
this:RegisterEvent("PLAYER_AURAS_CHANGED")
this:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
this:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")
this:RegisterEvent("ZONE_CHANGED_NEW_AREA")
this:RegisterEvent("PLAYER_AURAS_CHANGED")
this:RegisterEvent("PLAYER_TARGET_CHANGED")
this:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
this:RegisterEvent("CHAT_MSG_TEXT_EMOTE")
this:RegisterEvent("CHAT_MSG_EMOTE")
this:RegisterEvent("CHAT_MSG_YELL")
this:RegisterEvent("UNIT_HEALTH")
this:RegisterEvent("UNIT_SPELLCAST_SENT")
this:RegisterEvent("RESURRECT_REQUEST")
this:RegisterEvent("PLAYER_ALIVE")
this:RegisterEvent("PLAYER_UNGHOST")
this:RegisterEvent("PLAYER_DEAD")
this:RegisterEvent("READY_CHECK")
this:RegisterEvent("OnUpdate")


-- Saying Hello --
  DEFAULT_CHAT_FRAME:AddMessage("Hello you there, this AddOn is enabled by default!",0,0,1);
  
-- Slash Commands --
  SlashCmdList["Comix"] = Comix_Command;
	SLASH_Comix1 = "/Comix";
	SLASH_Comix2 = "/comix";
	
  SlashCmdList["ComixJoke"] = Comix_BadJoke;
	SLASH_ComixJoke1 = "/badjoke";

	dontfireonalive = false;
	loaded = false;
	unghosted = false;
	
-- Setting variables --
	Comix_ShakeEnabled = true;
	Comix_ShakeDuration = 1;
	Comix_ShakeIntensity = 70;
  Comix_x_coord = 0;
  Comix_y_coord = 0;
  Comix_Max_Scale = 2;
  ComixCurrentFrameCt = 1;
  ComixCritCount = 0;
  ComixBuffCount = 0;
  ComixAniSpeed = 1;
  ComixMaxCrits = 3;
  ComixKillCount = 0;
  Comix_CritPercent = 100;
  Comix_CritGap = 0;
  Comix_FinishHimGap = 0.2;
  Comix_CurrentImage = nil;
  Comix_NightfallCt = 0;
  Comix_Frames = {};
  Comix_FramesScale = {}
  Comix_FramesVisibleTime = {}
  Comix_FramesStatus = {}
  Comix_textures = {};
  Comix_CritSoundsEnabled = true;
  Comix_CritHealsEnabled = true;
  Comix_SpecialsEnabled = true;
  Comix_KillCountEnabled = true;
  Comix_DeathSoundEnabled = true;
  ComixKillCountSoundPlayed = false;
  Comix_HuggedNotFound = false;
  Comix_AddOnEnabled = true;
  Comix_SoundEnabled = true;
  Comix_BS_Update = false;
  Comix_BSEnabled = true;
  Comix_DemoShoutEnabled = true;
  Comix_ZoneEnabled = true;
  Comix_FinishTarget = true;
  Comix_BamEnabled = false;
  Comix_ImagesEnabled = true;
  Comix_FinishhimEnabled = true;
  Comix_NightfallProcced = true;
  Comix_NightfallEnabled = true;
  Comix_NightfallAutoTarget = false;
  Comix_NightfallCounter = false;
  Comix_CritGapEnabled = false;
  Comix_OneHit = false;
  Comix_NightfallAnnounce = false;
  Comix_NightfallGotTarget = false;
  Comix_BsShortDuration = true;
  Comix_HealorDmg = true;
  Comix_PlayerClass = UnitClass("player")
  
  Comix_CritFlashEnabled = true;
  Comix_HealFlashEnabled = true;
  Comix_BSSounds = true;
  Comix_DSSounds = true;
  Comix_BounceSoundEnabled = true;
  Comix_JumpCount = 0;
  Comix_ResSoundEnabled = true;
  Comix_ReadySoundEnabled = true;
  
  Comix_AbilitySoundsEnabled = true;
   
  forward = false;
  back = false;
  left = false;
  right = false;
  
  -- Hug Counter Variables --
  Comix_Hugs = {}
  Comix_Hugged = {}
  Comix_HugName = {}
  Comix_HugName[1] = UnitName("player")
  Comix_Hugs[1] = 0
  Comix_Hugged[1] = 0
  
-- Calling functions to Create Frames and Load The Images/Sounds -- 
  Comix_CreateFrames(); 
  Comix_LoaddaShite();
  TimeSinceLastUpdate = 0;
  Comix_DongSound(ComixSpecialSounds,6);
  
end

function startReadyCheck()

	if Comix_ReadySoundEnabled then
		Comix_DongSound(ComixReadySounds, math.random(1, ComixReadySoundsCt));
	end
end

hooksecurefunc("DoReadyCheck", startReadyCheck)

function PlayBounceSound()

local boing = false;

if forward or back or left or right then
	boing = true;
end

if IsMounted() then
	if not IsFlying() then
		if boing then
			Comix_JumpCount = Comix_JumpCount + 1;
		end
		if Comix_BounceSoundEnabled and boing then
			Comix_DongSound(ComixSpecialSounds, 8);
		end
	end
else
		Comix_JumpCount = Comix_JumpCount + 1;
		if Comix_BounceSoundEnabled then
			Comix_DongSound(ComixSpecialSounds, 8);
		end
end


end

hooksecurefunc("JumpOrAscendStart", PlayBounceSound)

function forwardstart()
	forward = true;
end

hooksecurefunc("MoveForwardStart", forwardstart)

function forwardstop()
	forward = false;
end

hooksecurefunc("MoveForwardStop", forwardstop)

function backstart()
	back = true;
end

hooksecurefunc("MoveBackwardStart", backstart)

function backstop()
	back = false;
end

hooksecurefunc("MoveBackwardStop", backstop)

function leftstart()
	left = true;
end

hooksecurefunc("StrafeLeftStart", leftstart)

function leftstop()
	left = false;
end

hooksecurefunc("StrafeLeftStop", leftstop)

function rightstart()
	right = true;
end

hooksecurefunc("StrafeRightStart", rightstart)

function rightstop()
	right = false;
end

hooksecurefunc("StrafeRightStop", rightstop)


function Comix_OnEvent()

if (Comix_AddOnEnabled) then


if event == "COMBAT_LOG_EVENT_UNFILTERED" then
--DEFAULT_CHAT_FRAME:AddMessage("COMBAT_LOG_EVENT_UNFILTERED fired "..arg2);
	--DEFAULT_CHAT_FRAME:AddMessage("Should fire on self event "..arg2);
	
		if arg2 == "SPELL_AURA_APPLIED" then
			if arg7 == UnitName("player") then
				--DEFAULT_CHAT_FRAME:AddMessage("Should fire on self event "..arg10);
				if arg10 == COMIX_BS then
					if Comix_BSEnabled then 
			        Comix_Pic(0, 0,ComixSpecialImages[1])
					
					if Comix_BSSounds then
						Comix_DongSound(ComixSpecialSounds,1)
					end
					end
				elseif arg10 == COMIX_DS or arg10 == COMIX_DR then
					if Comix_DemoShoutEnabled then
					Comix_Pic(0, 0,ComixSpecialImages[2])
			
					if Comix_DSSounds then
						Comix_DongSound(ComixSpecialSounds,math.random(2,3))
					end
					end
				end
			end
		end
	

	if bit.band(arg5, COMBATLOG_OBJECT_REACTION_FRIENDLY) > 0 then
	

		if arg2 == "SPELL_HEAL" then
			if arg4 == UnitName("player") then
				--don't do anything for heals casted by player here
			else
				if arg7 == UnitName("player") then --someone cast a heal on the player we need to fire on a crit
					if arg13 == 1 then
						if math.random(1,100) <= Comix_CritPercent then
							--heal cast on the player crit fire off stuff
							--DEFAULT_CHAT_FRAME:AddMessage("heal crit fire friendly");
							if Comix_HealFlashEnabled then
								UIFrameFlash( Comix_FrameFlash2, 0.5, 0.5, 2, false, 1, 0);
							end
							Comix_CallPic(ComixHolyHealImages[math.random(1, ComixHolyHealImagesCt)])
							if Comix_CritHealsEnabled then
								Comix_DongSound(ComixHealingSounds,math.random(1,ComixHealingSoundsCt))
							end
						end
					end
				end
			end
			--DEFAULT_CHAT_FRAME:AddMessage("Spell heal!! firing target = "..arg7);
		end
	end

	if bit.band(arg5, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
		
		
		if arg2 == "PARTY_KILL" then
			--DEFAULT_CHAT_FRAME:AddMessage("Should fire on self event "..arg2);
			KillCount()
		end
		

	--DEFAULT_CHAT_FRAME:AddMessage("Should fire on self event "..arg2);

		if arg2 == "SPELL_HEAL" then
			--DEFAULT_CHAT_FRAME:AddMessage("Spell heal firing arg11 = "..arg13);
				if arg13 == 1 then
					if math.random(1,100) <= Comix_CritPercent then
						--DEFAULT_CHAT_FRAME:AddMessage("heal crit fire mine");
						if Comix_HealFlashEnabled then
							if arg7 == UnitName("player") then
								UIFrameFlash( Comix_FrameFlash2, 0.5, 0.5, 2, false, 1, 0); --self
							else
								UIFrameFlash( Comix_FrameFlash4, 0.5, 0.5, 2, false, 1, 0);
							end
						end
						
						Comix_CallPic(ComixHolyHealImages[math.random(1, ComixHolyHealImagesCt)])
						if Comix_CritHealsEnabled then
							Comix_DongSound(ComixHealingSounds,math.random(1,ComixHealingSoundsCt))
						end
					end
				end
		end
		if arg2 == "SPELL_DAMAGE" then
		--DEFAULT_CHAT_FRAME:AddMessage("spell_dmg fired "..arg10.." "..arg11.." "..arg12);
		
			if arg17 == 1 then
				if math.random(1,100) <= Comix_CritPercent then
				if Comix_ShakeEnabled then
					ShakeScreen()
				end
				
				ComixCritCount = ComixCritCount + 1
				
				if ComixCritCount >= ComixMaxCrits then
					if Comix_SpecialsEnabled then
						Comix_DongSound(ComixSpecialSounds,4)
					end
					Comix_Pic(Comix_x_coord+math.random(-15,15),Comix_y_coord+math.random(-20,20),ComixSpecialImages[3])
					ComixCritCount = 0
				end
						
	          
				
				if Comix_CritSoundsEnabled then
					Comix_DongSound(ComixSounds)
				end
				if Comix_CritFlashEnabled then
					UIFrameFlash( Comix_FrameFlash3, 0.5, 0.5, 2, false, 1, 0);		 
				end
						if arg11 == 16 then
						Comix_CallPic(ComixFrostImages[math.random(1,ComixFrostImagesCt)]);
						elseif arg11 == 4 then
						Comix_CallPic(ComixFireImages[math.random(1,ComixFireImagesCt)]);
						elseif arg11 == 2 then
						Comix_CallPic(ComixHolyDmgImages[math.random(1,ComixHolyDmgImagesCt)]);
						elseif arg11 == 8 then
						Comix_CallPic(ComixNatureImages[math.random(1,ComixNatureImagesCt)]);
						elseif arg11 == 32 then
						Comix_CallPic(ComixShadowImages[math.random(1,ComixShadowImagesCt)]);
						elseif arg11 == 64 then
						Comix_CallPic(ComixArcaneImages[math.random(1,ComixArcaneImagesCt)]);
						elseif arg11 == 1 then
						Comix_CallPic(ComixImages[math.random(1,ComixImagesCt)]);
						end					
						
				end
			else
				ComixCritCount = 0
			end
			

		end
	
	if arg2 == "SWING_DAMAGE" then
	
		if arg14 == 1 then
		
			ComixCritCount = ComixCritCount + 1
			
			if ComixCritCount >= ComixMaxCrits then
				if Comix_SpecialsEnabled then
					Comix_DongSound(ComixSpecialSounds,4)
				end
				Comix_Pic(Comix_x_coord+math.random(-15,15),Comix_y_coord+math.random(-20,20),ComixSpecialImages[3])
				ComixCritCount = 0
			end
		
			if Comix_CritSoundsEnabled then
				Comix_DongSound(ComixSounds)
			end
			if Comix_CritFlashEnabled then
				UIFrameFlash( Comix_FrameFlash3, 0.5, 0.5, 2, false, 1, 0);		 
			end
			
			Comix_CallPic(ComixImages[math.random(1,ComixImagesCt)])
		else
			ComixCritCount = 0
		end
	end
end

end

-- END DEBUGGING


  
  if event == "READY_CHECK" then
	
	if Comix_ReadySoundEnabled then
		Comix_DongSound(ComixReadySounds, math.random(1, ComixReadySoundsCt));
	end
  end
  
  if event == "UNIT_HEALTH" then
  -- finish him --
    if Comix_FinishhimEnabled then
      if Comix_FinishTarget then 
        if UnitHealth("target") ~= 0 and UnitHealth("target") > 0 and UnitIsFriend("player","target") == nil then
          local TargetHealth = UnitHealth("target")
          if TargetHealth < Comix_FinishHimGap then
            Comix_DongSound(ComixSpecialSounds,12)
            Comix_FinishTarget = false
            Comix_OneHit = true;            
          end
        end  
      end    
    end  
  end
  
  

  
  if event == "PLAYER_ALIVE" then

	if UnitIsDeadOrGhost("player") == nil then
	 if dontfireonalive == false then
		if loaded then
			if not unghosted then
				if Comix_ResSoundEnabled then
					Comix_DongSound(ComixSpecialSounds, 18);
				end
			else
				unghosted = false;
			end
		else
			loaded = true;
		end
	 else
		dontfireonalive = false;
	 end
	
	end
  
  end
  
  if event == "PLAYER_DEAD" then
  
	unghosted = false;
	
	  -- Oh poor guy ... you died ... noob :P --
     if Comix_DeathSoundEnabled then
      --if UnitIsDead("player") and strfind(arg1, getglobal("COMIX_YOUUP")) then
        Comix_CallPic(ComixDeathImages[math.random(1, ComixDeathImagesCt)]);
		Comix_DongSound(ComixDeathSounds,math.random(1,ComixDeathSoundsCt))
        ComixKillCount = 0;
      --end
    end
   
  end
  
  if event == "PLAYER_UNGHOST" then
	unghosted = true;  
  end
  
  --res sound--
  if event == "RESURRECT_REQUEST" then
	unghosted = false;
	dontfireonalive = true;
	if Comix_ResSoundEnabled then
		Comix_DongSound(ComixSpecialSounds, 18);
	end
  end
  
  -- zone change sounds --
  if event == "ZONE_CHANGED_NEW_AREA" then
  local ininstance, instancetype = IsInInstance();

  
  if ininstance then
	if instancetype == "party" or instancetype == "raid" then
		if Comix_SpecialsEnabled then
			DEFAULT_CHAT_FRAME:AddMessage("[Dr. Evil] yells: Ladies and Gentlemen, Welcome to my Underground Lair!",1,0,0)
			Comix_DongSound(ComixSpecialSounds, 16); -- if specials are on we want a different sound when entering an instance, whether zone sounds are on or not --
		else
			if Comix_ZoneEnabled then
				Comix_DongSound(ComixZoneSounds,math.random(1,ComixZoneSoundsCt))
			end
		end
	else
		if Comix_ZoneEnabled then
			Comix_DongSound(ComixZoneSounds,math.random(1,ComixZoneSoundsCt))
		end
	end
	else
	if Comix_ZoneEnabled then
			Comix_DongSound(ComixZoneSounds,math.random(1,ComixZoneSoundsCt))
		end
	end
	
  
  end
  
  
	
  
  -- if event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_COMBAT_SELF_HITS" then 
	
	
	
	
    -- if Comix_OneHit then
      -- if UnitHealth("target") <= 0 then
        -- Comix_OneHit = false;
		-- Comix_DongSound(ComixOneHitSounds,math.random(1,ComixOneHitSoundsCt))
		-- else
        -- Comix_OneHit = false;
      -- end  
      
    -- elseif Comix_CritGapEnabled then  
        -- if strfind(arg1, getglobal("COMIX_CRITS")) or 
           -- strfind(arg1, getglobal("COMIX_CRIT")) then
          -- local damagedone = 0;
          -- if strfind(arg1,'%d+') then    
            -- damagedone = tonumber(strsub(arg1, strfind(arg1,'%d+')))
          -- end  
          
          -- if damagedone > Comix_CritGap then
            -- local wtfbbq = math.random(1,ComixOneHitSoundsCt)
					  -- ShakeScreen();
				-- Comix_DongSound(ComixOneHitSounds,wtfbbq)
			   -- Comix_Pic(0,0,ComixMortalCombatImages[wtfbbq])
          -- end
        -- end
      
    -- else
      -- if ComixCritCount == 0 then
        -- if strfind(arg1, getglobal("COMIX_CRITS")) or 
           -- strfind(arg1, getglobal("COMIX_CRIT")) then
          -- ComixCritCount = 1
          -- if math.random(1,100) <= Comix_CritPercent then
					 -- ShakeScreen();
				-- if Comix_CritSoundsEnabled then
					-- Comix_DongSound(ComixSounds)
				-- end
		     -- Comix_CallPic(Comix_DetermineDmgType(arg1));
		   
		   -- if Comix_CritFlashEnabled then
				-- UIFrameFlash( Comix_FrameFlash3, 0.5, 0.5, 2, false, 1, 0);		 
		   -- end
		   
          -- end
        -- end
        
      -- elseif ComixCritCount < ComixMaxCrits then
        -- if strfind(arg1, getglobal("COMIX_CRITS")) or 
           -- strfind(arg1, getglobal("COMIX_CRIT")) then
          -- ComixCritCount = ComixCritCount+1
          -- if math.random(1,100) <= Comix_CritPercent then
            -- if ComixMaxCrits -1 ~= ComixCritCount then

			 -- if Comix_CritSoundsEnabled then
				-- Comix_DongSound(ComixSounds)
		
			-- end
            -- end  
					  -- ShakeScreen();
            -- Comix_Pic(Comix_x_coord+10,Comix_y_coord-15,Comix_DetermineDmgType(arg1))    
          -- end
        -- else
          -- ComixCritCount = 0;
        -- end
             
      -- elseif ComixCritCount >= ComixMaxCrits then
        -- if strfind(arg1, getglobal("COMIX_CRITS")) or 
           -- strfind(arg1, getglobal("COMIX_CRIT")) then
          -- ComixCritCount = 0
					-- ShakeScreen();
          -- Comix_DongSound(ComixSpecialSounds,4)
          -- Comix_Pic(Comix_x_coord+math.random(-15,15),Comix_y_coord+math.random(-20,20),ComixSpecialImages[3])
        -- else
          -- ComixCritCount = 0;
        -- end
      -- end       
    -- end     
  -- end
 
    if event == "CHAT_MSG_EMOTE" then
	
	if Comix_SpecialsEnabled then
		if strfind(arg1, "senses a bad joke") then
	
			Comix_DongSound(ComixSpecialSounds, 17);
		end
	end
	
   end
 
 -- Ability Sounds Checks - well besides cannibalize and sprint/dash --
   if event == "UNIT_SPELLCAST_SENT" then
   		   if Comix_DemoShoutEnabled then
				if arg2 == COMIX_DS or arg2 == COMIX_DR then
					Comix_Pic(0, 0,ComixSpecialImages[2])
				end
			end
     if Comix_AbilitySoundsEnabled then  
			if arg2 == COMIX_ICEBLOCK then
				Comix_DongSound(ComixAbilitySounds, 2);
			elseif arg2 == COMIX_FLARE then
				Comix_DongSound(ComixAbilitySounds, 3);
			elseif arg2 == COMIX_CANNIBALIZE then
				Comix_DongSound(ComixAbilitySounds, 1);
			elseif arg2 == COMIX_SPRINT or arg2 == COMIX_DASH then
				Comix_DongSound(ComixSpecialSounds,11)
			elseif arg2 == COMIX_DS or arg2 == COMIX_DR then
			   if Comix_DemoShoutEnabled then
					if Comix_DSSounds then
						Comix_DongSound(ComixSpecialSounds,math.random(2,3))
					end
				end
			end
     end  
   end   

    
  
 -- if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" or event == "CHAT_MSG_SPELL_PARTY_BUFF" or event == "CHAT_MSG_SPELL_SELF_BUFF" or event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF" then
   

 -- Gettin Battle Shout while not having the Buff --
   -- if strfind(arg1,getglobal("COMIX_BS")) then
      -- if Comix_BSEnabled then 
        -- Comix_Pic(0, 0,ComixSpecialImages[1])
		
		-- if Comix_BSSounds then
			-- Comix_DongSound(ComixSpecialSounds,1)
		-- end
		
        -- Comix_BS_Update = true
      -- end
   
   
  -- end
    -- Disabling the "OnUpdate" Version of Battle Shout when Buff Fades -- 
    -- if event =="CHAT_MSG_SPELL_AURA_GONE_SELF" then
      -- if strfind(arg1, getglobal("COMIX_BS")) then
        -- Comix_BS_Update = false
        -- Comix_BsShortDuration = true
      -- end
    -- end    
  -- Counting the Amount of Buffs --  
  -- if event == "PLAYER_AURAS_CHANGED" then
    -- for i = 0,15 do
      -- local BuffzorsBuffer = GetPlayerBuff(i)
      -- if BuffzorsBuffer == nil then
        -- return
      -- else
        -- ComixBuffCount = i;
      -- end 
    -- end        
  -- end
  
  -- Demo Shout & Demo Roar -- 
  -- if event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" then
    -- if strfind(arg1,getglobal("COMIX_DS")) or strfind(arg1,getglobal("COMIX_DR")) then
      -- if Comix_DemoShoutEnabled then
        -- Comix_Pic(0, 0,ComixSpecialImages[2])
		
		-- if Comix_DSSounds then
			-- Comix_DongSound(ComixSpecialSounds,math.random(2,3))
		-- end
		
      -- end
		-- end
	-- end

	-- Nightfall proc -        
  -- if event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" then
    -- if strfind(arg1,getglobal("COMIX_SV")) then
      -- if Comix_NightfallAnnounce and Comix_NightfallEnabled then
        -- SendChatMessage("[COMIX]NIGHTFALL PROCC ON "..UnitName("target"), "YELL",  getglobal("COMIX_LANGUAGE"))
        -- Comix_Pic(0,0,ComixSpecialImages[14])
        -- Comix_DongSound(ComixSpecialSounds,14)
        -- Comix_NightfallProcced = false;      
      -- end  
    -- end 
  -- end
  
  -- if event == "CHAT_MSG_YELL" then
    -- if strfind(arg1,"NIGHTFALL PROCC ON ") and strfind(arg1,"COMIX") then
      -- if Comix_NightfallProcced then
        -- if Comix_NightfallGotTarget == false then
          -- Comix_Pic(0,0,ComixSpecialImages[5])
          -- Comix_DongSound(ComixSpecialSounds,14)  
          -- if Comix_NightfallAutoTarget then
            -- local targeto = strsub(arg1,27,strlen(arg1))
            -- if targeto ~= nil then
              -- DEFAULT_CHAT_FRAME:AddMessage("[Nightfall] : Autotargetting "..targeto.." by assisting "..arg2)
              -- AssistByName(arg2)
              -- Comix_NightfallCounter = true
              -- Comix_NightfallGotTarget = true
              -- Comix_NightfallCt = 0;
            -- end  
          -- end
        -- end 
      -- else
        -- Comix_NightfallProcced = true;
        -- Comix_NightfallGotTarget = false;
      -- end
    -- end     
  -- end
--end
  -- Special Target Sounds --
  if event == "PLAYER_TARGET_CHANGED" then
    if UnitName("target") == getglobal("COMIX_BIGGLESWORTH") then
      Comix_DongSound(ComixSpecialSounds,5)
      DEFAULT_CHAT_FRAME:AddMessage("[Dr. Evil] yells: That makes me angry and when Dr. Evil gets angry Mr. Bigglesworth gets upset and when Mr. Bigglesworth gets upset...... PPL DIE!!!!!!!!11111oneoneoneoneeleveneleven",1,0,0)
      DEFAULT_CHAT_FRAME:AddMessage("[Venomia] yells: I COMMAND YOU!!! LEAVE THE CAT ALIVE OR YOU GET -50DKP!!!! (rly)",1,0,0)
    
    elseif UnitName("target") == getglobal("COMIX_REPAIRBOT") or UnitName("target") == getglobal("COMIX_REPAIRBOT2") then
      Comix_DongSound(ComixSpecialSounds,7)
      DEFAULT_CHAT_FRAME:AddMessage("["..UnitName("target").."]".." says: All your base, r belong to us")
	  
	elseif UnitName("target") == getglobal("COMIX_MUFFIN") then
		Comix_DongSound(ComixSpecialSounds, 10)
		DEFAULT_CHAT_FRAME:AddMessage("Do you know the Muffin Man???", 0,1,0)
        
    end
    
    Comix_FinishTarget = true;
  end
       
    

 -- if event == "CHAT_MSG_COMBAT_HOSTILE_DEATH" then
	
  -- Kill Counter --  
  
  --end
  
  

  
  -- Hug Coounter .. FU String Manipulation!!! -- 
  if event == "CHAT_MSG_TEXT_EMOTE" then
	  if strfind(arg1, getglobal("COMIX_HUG")) or strfind(arg1,getglobal("COMIX_HUGS")) then
      local HuggerNotFound = true
      local HuggedNotFound = true   
      local comix_the_hugged_one = nil
      if strfind(arg1,getglobal("COMIX_HUGS")) then
        if GetLocale() == "frFR" then
          comix_the_hugged_one = strsub(arg1,strfind(arg1,'%a+',13))
        else
          local gappie = tonumber(getglobal("COMIX_HUGGAP")) 
          if arg2 == UnitName("player") then
            gappie = gappie + 3 
          else 
            gappie = gappie + strlen(arg2)
          end     
          comix_the_hugged_one = strsub(arg1,strfind(arg1,'%a+',gappie))
          
        end 
      elseif strfind(arg1,"vous serre ") then
        comix_the_hugged_one = UnitName("player")     
      elseif strfind(arg1, getglobal("COMIX_HUG")) then        
        local gappie = tonumber(getglobal("COMIX_HUGGAP")) 
        if arg2 == UnitName("player") then
          gappie = gappie + 3 
        else 
          gappie = gappie + strlen(arg2)
        end    
        comix_the_hugged_one = strsub(arg1,strfind(arg1,'%a+',gappie))
                
      end 
    
      if strfind(comix_the_hugged_one, getglobal("COMIX_YOULOW")) then
        comix_the_hugged_one = UnitName("player")
      end

        for i, line in ipairs(Comix_HugName) do
          if comix_the_hugged_one == getglobal("COMIX_YOULOW") then
            comix_the_hugged_one = UnitName("player")
          end

          if Comix_HugName[i] == arg2 then
            if not strfind(arg1, getglobal("COMIX_NEED")) then
              Comix_Hugs[i] = Comix_Hugs[i]+1
              HuggerNotFound = false
            end      
          end
          
          if Comix_HugName[i] == comix_the_hugged_one then
             Comix_Hugged[i] = Comix_Hugged[i]+1    
             HuggedNotFound = false
          end
        
        end
    
        if HuggedNotFound then
          if not strfind(arg1, getglobal("COMIX_NEED")) then
            Comix_HugName[getn(Comix_HugName)+1] = comix_the_hugged_one
            Comix_Hugged[getn(Comix_HugName)] = 1
            Comix_Hugs[getn(Comix_HugName)] = 0
            Comix_HuggedNotFound = false;
          end   
        end 
        
        if HuggerNotFound then
          if not strfind(arg1, getglobal("COMIX_NEED")) then
            Comix_HugName[getn(Comix_HugName)+1] = arg2
            Comix_Hugs[getn(Comix_HugName)] = 1
            Comix_Hugged[getn(Comix_HugName)] = 0
            Comix_HuggedNotFound = false;
          end 
        end
         
        for i,line in ipairs(Comix_HugName) do
          for j, line in ipairs(Comix_HugName) do
            if Comix_Hugged[i] > Comix_Hugged[j] then
              local Comix_TempHugged = Comix_Hugged[j]
              local Comix_TempHugs = Comix_Hugs[j]
              local Comix_TempHugName = Comix_HugName[j]
              Comix_Hugged[j] = Comix_Hugged[i]
              Comix_Hugs[j] = Comix_Hugs[i]
              Comix_HugName[j] = Comix_HugName[i]
              Comix_Hugged[i] = Comix_TempHugged
              Comix_Hugs[i] = Comix_TempHugs
              Comix_HugName[i] = Comix_TempHugName
            end  
          end
        end   
    end
  end 


  
 
end   
end    

function KillCount()
  if Comix_KillCountEnabled then
      
      --if strfind(arg1,getglobal("COMIX_YOUUP")) then
        ComixKillCount = ComixKillCount +1;
        ComixKillCountSoundPlayed = false; 
      --end    
    
      if ComixKillCountSoundPlayed == false then  
        if ComixKillCount == 2 then
          Comix_DongSound(ComixKillCountSounds,1)
          ComixKillCountSoundPlayed = true 
        elseif ComixKillCount == 5 then
          Comix_DongSound(ComixKillCountSounds,2)
          ComixKillCountSoundPlayed = true 
        elseif ComixKillCount == 8 then
          Comix_DongSound(ComixKillCountSounds,3)
          ComixKillCountSoundPlayed = true 
        elseif ComixKillCount == 10 then
          Comix_DongSound(ComixKillCountSounds,4)
          ComixKillCountSoundPlayed = true 
        elseif ComixKillCount == 15 then
          Comix_DongSound(ComixKillCountSounds,5)
          ComixKillCountSoundPlayed = true 
        elseif ComixKillCount == 20 then
          Comix_DongSound(ComixKillCountSounds,6)
          ComixKillCountSoundPlayed = true 
        elseif ComixKillCount == 30 then
          Comix_DongSound(ComixKillCountSounds,7)
          ComixKillCountSoundPlayed = true 
        elseif ComixKillCount == 40 then
          Comix_DongSound(ComixKillCountSounds,8)
          ComixKillCountSoundPlayed = true 
        elseif ComixKillCount == 50 then
          Comix_DongSound(ComixKillCountSounds,9)
          ComixKillCountSoundPlayed = true 
        end    
      end
    end  
end

function ShakeScreen()
	if Comix_ShakeEnabled then
		if not IsShaking then
			OldWorldFramePoints = {};
			for i = 1, WorldFrame:GetNumPoints() do
				local point, frame, relPoint, xOffset, yOffset = WorldFrame:GetPoint(i);
				OldWorldFramePoints[i] = {
					["point"] = point,
					["frame"] = frame,
					["relPoint"] = relPoint,
					["xOffset"] = xOffset,
					["yOffset"] = yOffset,
				}
			end
			IsShaking = Comix_ShakeDuration;
		end
	end
end

Comix_UpdateInterval = .01
function Comix_OnUpdate(elapsed)
local TimeSinceLastUpdate = 0;
if elapsed == nil then 
  elapsed = 0
end
 
TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed; 
 
  while (TimeSinceLastUpdate > Comix_UpdateInterval) do
 
	-- ScreenShake
			if type(IsShaking) == "number" then
			IsShaking = IsShaking - elapsed;
			if IsShaking <= 0 then
				IsShaking = false;
				WorldFrame:ClearAllPoints();
				for index, value in pairs(OldWorldFramePoints) do
					WorldFrame:SetPoint(value.point, value.xOffset, value.yOffset);
				end
			else
				WorldFrame:ClearAllPoints();
				local moveBy;
				moveBy = math.random(-100, 100)/(101 - Comix_ShakeIntensity);
				for index, value in pairs(OldWorldFramePoints) do
					WorldFrame:SetPoint(value.point, value.xOffset + moveBy, value.yOffset + moveBy);
				end
			end
		end	
 
	  -- Battleshout Buff Check if Battleshout is active  --
	    if Comix_BS_Update then
	      for i = 0,ComixBuffCount do
	        local buffTexture = GetPlayerBuffTexture(i)
	        if buffTexture ~= nil then
	          if string.find(buffTexture,"BattleShout") then
	            local timeLeft = tonumber(GetPlayerBuffTimeLeft(i))
	            if (timeLeft <= 180.000)and (timeLeft >= 179.990) then
	              Comix_BsShortDuration = false
	              Comix_Pic(0, 0,ComixSpecialImages[1])
				  if Comix_BSSounds then
					Comix_DongSound(ComixSpecialSounds,1)
				  end
	            elseif Comix_BsShortDuration then
	              if (timeLeft <= 120.000)and (timeLeft >= 119.990) then
	                Comix_Pic(0, 0,ComixSpecialImages[1])
				if Comix_BSSounds then
					Comix_DongSound(ComixSpecialSounds,1)
				  end
	              end
	            elseif timeLeft < 119.00 then
	               Comix_BsShortDuration = true    
	            end      
	          end
	        end    
	      end          
	    end
  
  --The Picture Animation
    for i = 1,5 do
      if Comix_Frames[i] ~= nil then
        if Comix_Frames[i]:IsVisible() then
          if Comix_FramesStatus[i] == 0 then
            Comix_FramesScale[i] = Comix_FramesScale[i]*1.1*ComixAniSpeed 
            Comix_Frames[i]:SetScale(Comix_FramesScale[i])
            if Comix_FramesScale[i] >= Comix_Max_Scale then
              Comix_FramesStatus[i] = 1    
            end
          elseif Comix_FramesStatus[i] == 1 then
            Comix_FramesScale[i] = Comix_FramesScale[i]*0.8
            Comix_Frames[i]:SetScale(Comix_FramesScale[i])
            if Comix_FramesScale[i] >= Comix_Max_Scale*0.4 then
              Comix_FramesStatus[i] = 2
            end
          elseif Comix_FramesStatus[i] == 2 then
            Comix_FramesVisibleTime[i] = Comix_FramesVisibleTime[i] + 0.01
            if Comix_FramesVisibleTime[i] >= 1.0 then
              Comix_FramesStatus[i] = 3
            end  
          elseif Comix_FramesStatus[i] == 3 then
            Comix_FramesScale[i] = Comix_FramesScale[i]*0.5
            Comix_Frames[i]:SetScale(Comix_FramesScale[i])
            if Comix_FramesScale[i] <= 0.2 then
              Comix_Frames[i]:Hide()
              Comix_FramesStatus[i] = 0
              Comix_FramesScale[i] = 0.2
              Comix_FramesVisibleTime[i] = 0
            end
          end
        end            
      end    
    end  
  
  if Comix_NightfallCounter then
    Comix_NightfallCt = Comix_NightfallCt + elapsed
    if Comix_NightfallCt >= 5.0 then
      Comix_NightfallCounter = false;
      Comix_NightfallGotTarget = false;
      TargetLastTarget();
    end
  end 
    
  TimeSinceLastUpdate = TimeSinceLastUpdate-Comix_UpdateInterval;
  end   



end
	
function Comix_Command(Nerd)
  
  Nerd = strlower(Nerd)
   
  if (Nerd == "create") then 
    DEFAULT_CHAT_FRAME:AddMessage("Me Creates: Hello World")
    Comix_DongSound(ComixSpecialSounds,15)
	
	
	--elseif(Nerd == "deathtest") then
	--Comix_CallPic(ComixDeathImages[math.random(1, ComixDeathImagesCt)]);

    --elseif(Nerd == "test1") then
	--UIFrameFlash( Comix_FrameFlash1, 0.5, 0.5, 2, false, 1, 0);	
		
	--elseif(Nerd == "test2") then
	--UIFrameFlash( Comix_FrameFlash2, 0.5, 0.5, 2, false, 1, 0);	
		
	--elseif(Nerd == "test3") then
	--UIFrameFlash( Comix_FrameFlash3, 0.5, 0.5, 2, false, 1, 0);	
	
	--elseif(Nerd == "test4") then
	--UIFrameFlash( Comix_FrameFlash4, 0.5, 0.5, 2, false, 1, 0);	
	
  elseif (Nerd == "hide") then 
    Comix_Framehide();
  
  elseif (Nerd == "pic") then 
   Comix_CallPic(ComixImages[math.random(1,ComixImagesCt)]);

  elseif (Nerd == "specialpic") then 
   Comix_CallPic(ComixSpecialImages[math.random(1,ComixSpecialCt)]);

  elseif (Nerd == "on") then
    Comix_AddOnEnabled = true;
    Comix_Frame:Show()
    DEFAULT_CHAT_FRAME:AddMessage("Comix enabled!")

  elseif (Nerd == "off") then
    Comix_AddOnEnabled = false;
    Comix_Frame:Hide()
    DEFAULT_CHAT_FRAME:AddMessage("Comix disabled :'(")
  
  elseif (Nerd == "sound on") then
    Comix_SoundEnabled = true
    DEFAULT_CHAT_FRAME:AddMessage("Comix Sound is now turned on")   
  
  elseif (Nerd == "sound off") then
    Comix_SoundEnabled = false
        DEFAULT_CHAT_FRAME:AddMessage("Comix Sound is now turned off")  

  elseif (Nerd == "demoshout on") then
    Comix_DemoShoutEnabled = true
    DEFAULT_CHAT_FRAME:AddMessage("Comix Demo Shout is now turned on")   
  
  elseif (Nerd == "demoshout off") then
    Comix_DemoShoutEnabled = false
        DEFAULT_CHAT_FRAME:AddMessage("Comix Demo Shout is now turned off")  
		
  elseif (Nerd == "demoshoutsound on") then
    Comix_DSSounds = true
    DEFAULT_CHAT_FRAME:AddMessage("Comix Demo Shout sound is now turned on")   
  
  elseif (Nerd == "demoshoutsound off") then
    Comix_DSSounds = false
        DEFAULT_CHAT_FRAME:AddMessage("Comix Demo Shout sound is now turned off") 

  elseif (Nerd == "bs on") then
    Comix_BSEnabled = true
    DEFAULT_CHAT_FRAME:AddMessage("Comix Battle Shout is now turned on")   
  
  elseif (Nerd == "bs off") then
    Comix_BSEnabled = false
        DEFAULT_CHAT_FRAME:AddMessage("Comix Battle Shout is now turned off")  
		
		elseif (Nerd == "bssound on") then
    Comix_BSSounds = true
    DEFAULT_CHAT_FRAME:AddMessage("Comix Battle Shout sound is now turned on")   
  
  elseif (Nerd == "bssound off") then
    Comix_BSSounds = false
        DEFAULT_CHAT_FRAME:AddMessage("Comix Battle Shout sound is now turned off")  

  elseif (Nerd == "zoning on") then
    Comix_ZoneEnabled = true
    DEFAULT_CHAT_FRAME:AddMessage("Comix Zoning Sounds are now turned on")   
  
  elseif (Nerd == "zoning off") then
    Comix_ZoneEnabled = false
        DEFAULT_CHAT_FRAME:AddMessage("Comix Zoning Sound is now turned off")
  
  elseif (Nerd == "bam on") then
    Comix_BamEnabled = true
		DEFAULT_CHAT_FRAME:AddMessage("BAM is now turned on")
    
  elseif (Nerd == "bam off") then
    Comix_BamEnabled = false
		DEFAULT_CHAT_FRAME:AddMessage("BAM is now turned off")
    
  elseif (Nerd == "images on") then
    Comix_ImagesEnabled = true
		DEFAULT_CHAT_FRAME:AddMessage("Comix Images are now turned on")
	
  elseif (Nerd == "images off") then
    Comix_ImagesEnabled = false    
		DEFAULT_CHAT_FRAME:AddMessage("Comix Images are now turned off")
  
  elseif (Nerd == "finish on") then  
    Comix_FinishhimEnabled = true
		DEFAULT_CHAT_FRAME:AddMessage("Finish Him is now turned on")

  elseif (Nerd == "finish off") then  
    Comix_FinishhimEnabled = false
		DEFAULT_CHAT_FRAME:AddMessage("Finish Him is now turned off")
		
  elseif (Nerd == "dsound") then
    if Comix_DeathSoundEnabled then
      Comix_DeathSoundEnabled = false
      DEFAULT_CHAT_FRAME:AddMessage("Comix Death Sound is now turned off")
    else 
      Comix_DeathSoundEnabled = true
      DEFAULT_CHAT_FRAME:AddMessage("Comix Death Sound is now turned on")    
    end       
  
  elseif (Nerd == "nfall") then
    if Comix_NightfallAnnounce then
      Comix_NightfallAnnounce = false
      DEFAULT_CHAT_FRAME:AddMessage("Comix Night Fall Announce is now turned off")
    else 
      Comix_NightfallAnnounce = true
      DEFAULT_CHAT_FRAME:AddMessage("Comix Night Fall Announce is now turned on")    
    end 
  
  elseif (Nerd == "KillCount") then
    if Comix_KillCountEnabled then
      Comix_KillCountEnabled = false
      DEFAULT_CHAT_FRAME:AddMessage("Comix Kill Count is now turned off")
    else 
      Comix_KillCountEnabled = true
      DEFAULT_CHAT_FRAME:AddMessage("Comix Kill Count is now turned on")    
    end
     
  elseif string.find(Nerd,"anispeed") then    
    local ComixNerd = string.find(Nerd, " ")
    local buffer = tonumber(string.sub(Nerd, ComixNerd, ComixNerd + 1, string.len(Nerd)))
    if buffer < 1 or buffer > 3 then
      DEFAULT_CHAT_FRAME:AddMessage("Value not accepted, try smth between 1 and 3")
    else  
      ComixAniSpeed = buffer;
      DEFAULT_CHAT_FRAME:AddMessage("Animation Speed set to "..ComixAniSpeed)
    end
     
  elseif string.find(Nerd, "scale") then
    local ComixNerd = string.find(Nerd, " ")
    local buffer = tonumber(string.sub(Nerd, ComixNerd, ComixNerd + 1, string.len(Nerd)))
    if buffer < 1.5 or buffer > 3 then
      DEFAULT_CHAT_FRAME:AddMessage("Value not accepted, try smth between 1.5 and 3")
    else  
      Comix_Max_Scale = buffer;
      DEFAULT_CHAT_FRAME:AddMessage("Scale set on "..Comix_Max_Scale)
    end
    
  elseif string.find(Nerd, "crits") then
    local ComixNerd = string.find(Nerd, " ")
    local buffer = tonumber(string.sub(Nerd, ComixNerd, ComixNerd + 1, string.len(Nerd)))
      ComixMaxCrits = buffer;
      DEFAULT_CHAT_FRAME:AddMessage("Amount of crits needed for Impressive set to "..ComixMaxCrits)
  
  elseif string.find(Nerd, "critpercent") then
    local ComixNerd = string.find(Nerd, " ")
    local buffer = tonumber(string.sub(Nerd, ComixNerd, ComixNerd + 1, string.len(Nerd)))
    if buffer <= 100 and buffer >= 0 then 
      Comix_CritPercent = buffer;
      DEFAULT_CHAT_FRAME:AddMessage("Amount of crits needed for Impressive set to "..ComixMaxCrits)
    else
      DEFAULT_CHAT_FRAME:AddMessage("You can set Crit-Percent only between 0 and 100 -.- anything else would be senseless or not??")
    end   
  
  elseif (Nerd == "clearhug") then
    for i, line in ipairs(Comix_HugName) do
      Comix_HugName[i] = nil ;
      Comix_Hugged[i] = nil;
      Comix_Hugs[i] = nil; 
    end 
    Comix_HugName[1] = UnitName("player")
    Comix_Hugs[1] = 0
    Comix_Hugged[1] = 0 
  
  elseif (Nerd == "showhug") then
    for i = 1,5 do
      if Comix_HugName[i] ~= nil then
        DEFAULT_CHAT_FRAME:AddMessage("[Hug Report]: "..Comix_HugName[i].." has been hugged " ..Comix_Hugged[i].." times and Hugged "..Comix_Hugs[i].." times",0,0,1)
      end
    end 
  
  elseif (Nerd == "reporthug") then
    for i = 1,5 do
      if Comix_HugName[i] ~= nil then
        SendChatMessage("[Hug Report]: "..Comix_HugName[i].." has been hugged " ..Comix_Hugged[i].." times and Hugged "..Comix_Hugs[i].." times", "SAY")
      end
    end
       
	   
	elseif (Nerd == "clearjump") then
		Comix_JumpCount = 0;
		DEFAULT_CHAT_FRAME:AddMessage("Jump Counter Reset",0,0,1)
  
  elseif (Nerd == "showjump") then
        DEFAULT_CHAT_FRAME:AddMessage("[Jump Report]: "..UnitName("player").." has jumped " ..Comix_JumpCount.." times",0,0,1)
      
  
  elseif (Nerd == "reportjump") then
        SendChatMessage("[Jump Report]: "..UnitName("player").." has jumped " ..Comix_JumpCount.." times", "SAY")
    
    
	   
	elseif (Nerd == "critsound") then
	if Comix_CritSoundsEnabled then
      Comix_CritSoundsEnabled = false
      DEFAULT_CHAT_FRAME:AddMessage("Comix Crit Sounds are now turned off")
    else 
      Comix_CritSoundsEnabled = true
      DEFAULT_CHAT_FRAME:AddMessage("Comix Crit Sounds now turned on")    
    end
	
	
	elseif (Nerd == "healsound") then
	if Comix_CritHealsEnabled then
      Comix_CritHealsEnabled = false
      DEFAULT_CHAT_FRAME:AddMessage("Comix Heal Sounds are now turned off")
    else 
      Comix_CritHealsEnabled = true
      DEFAULT_CHAT_FRAME:AddMessage("Comix Heal Sounds now turned on")    
    end
	
	
	elseif (Nerd == "critflash") then
	if Comix_CritFlashEnabled then
      Comix_CritFlashEnabled = false
      DEFAULT_CHAT_FRAME:AddMessage("Comix Crit Flash is now turned off")
    else 
      Comix_CritFlashEnabled = true
      DEFAULT_CHAT_FRAME:AddMessage("Comix Crit Flash now turned on")    
    end
	

	elseif (Nerd == "healflash") then
	if Comix_HealFlashEnabled then
      Comix_HealFlashEnabled = false
      DEFAULT_CHAT_FRAME:AddMessage("Comix Heal Flash is now turned off")
    else 
      Comix_HealFlashEnabled = true
      DEFAULT_CHAT_FRAME:AddMessage("Comix Heal Flash now turned on")    
    end
	
	elseif (Nerd == "boing") then
	if Comix_BounceSoundEnabled then
      Comix_BounceSoundEnabled = false
      DEFAULT_CHAT_FRAME:AddMessage("Comix Boing sound is now turned off")
    else 
      Comix_BounceSoundEnabled = true
      DEFAULT_CHAT_FRAME:AddMessage("Comix Boing sound now turned on")    
    end
	
  elseif (Nerd == "help") then
    DEFAULT_CHAT_FRAME:AddMessage("Use /comix on|off to enable|disable AddOn")
    DEFAULT_CHAT_FRAME:AddMessage("Use /comix create to create a cool MSG")
    DEFAULT_CHAT_FRAME:AddMessage("Use /comix pic to show a Frame")
    DEFAULT_CHAT_FRAME:AddMessage("Use /comix specialpic to show a Frame with a special")
    DEFAULT_CHAT_FRAME:AddMessage("Use /comix hide to hide all Frames")
    DEFAULT_CHAT_FRAME:AddMessage("Use /comix scale <Value 1.5-3> to scale animation of all Frames")    
    DEFAULT_CHAT_FRAME:AddMessage("Use /comix anispeed <Value 1-3> to set animation speed (popping up of the images)")    
    DEFAULT_CHAT_FRAME:AddMessage("Use /comix sound on|off to turn sound on|off")
	DEFAULT_CHAT_FRAME:AddMessage("Use /comix critsound to toggle Crit sounds.")
	DEFAULT_CHAT_FRAME:AddMessage("Use /comix healsound to toggle Heal sounds.")
    DEFAULT_CHAT_FRAME:AddMessage("Use /comix demoshout on|off to turn Demo Shout/Roar grafix on|off (will also disable sounds if on)") 
	DEFAULT_CHAT_FRAME:AddMessage("Use /comix demoshoutsound on|off to turn Demo Shout/Roar sound on|off")
    DEFAULT_CHAT_FRAME:AddMessage("Use /comix bs on|off to turn Battle Shout grafix on|off (will also disable sounds if on)") 
	DEFAULT_CHAT_FRAME:AddMessage("Use /comix bssound on|off to turn Battle Shout sound on|off") 
    DEFAULT_CHAT_FRAME:AddMessage("Use /comix zoning on|off to turn Zoning sounds on|off")
    DEFAULT_CHAT_FRAME:AddMessage("Use /comix crits <Value> to set the amount of crits needed for an Impressive")
    DEFAULT_CHAT_FRAME:AddMessage("Use /comix images on|off to show or hide the images on specials and crits")          
    DEFAULT_CHAT_FRAME:AddMessage("Use /comix specials on|off to turn specials on or off ( eastereggs cant be turned off though :P )")
    DEFAULT_CHAT_FRAME:AddMessage("Use /comix finish on|off to turn <Finish him>-sound on 20% mob health on or off")          
    DEFAULT_CHAT_FRAME:AddMessage("Use /comix bam on|off to enable BamSound only or hear Comix Sounds on crits!")          
    DEFAULT_CHAT_FRAME:AddMessage("Use /comix showhug to show the Hugs done in your Chat-Frame.") 
    DEFAULT_CHAT_FRAME:AddMessage("Use /comix reporthug to report the Hugging done to /say.") 
    DEFAULT_CHAT_FRAME:AddMessage("Use /comix clearhug to clear all Hugs done.") 
	DEFAULT_CHAT_FRAME:AddMessage("Use /comix nfall to toggle Nightfall proc announce.")
	DEFAULT_CHAT_FRAME:AddMessage("Use /comix dsound to toggle death sound.")
	DEFAULT_CHAT_FRAME:AddMessage("Use /comix critflash to toggle Crit flashes.")
	DEFAULT_CHAT_FRAME:AddMessage("Use /comix healflash to toggle Heal flashes.")
	DEFAULT_CHAT_FRAME:AddMessage("Use /comix boing to toggle Boing sound.")
  
  else 
    comix_options_frame:Show()
    
  end
  
end

function Comix_BadJoke()
	SendChatMessage("senses a bad joke", "EMOTE");
end






function Comix_DongSound(SoundTable,Sound)

  if Comix_SoundEnabled then 
   if SoundTable == ComixSounds then  
     if Comix_BamEnabled then
	   --PlaySound("GLUESCREENSMALLBUTTONMOUSEDOWN");
       PlaySoundFile("Interface\\AddOns\\Comix\\Sounds\\"..ComixSpecialSounds[13])
     else  
       local randsound = math.random(1,ComixSoundsCt)
	 --  PlaySound("GLUESCREENSMALLBUTTONMOUSEDOWN");
       PlaySoundFile("Interface\\AddOns\\Comix\\Sounds\\"..SoundTable[randsound]);
     end
   else 
   --PlaySound("GLUESCREENSMALLBUTTONMOUSEDOWN");
     PlaySoundFile("Interface\\AddOns\\Comix\\Sounds\\"..SoundTable[Sound]);
   end
  end
   
end



function Comix_Pic(x,y,Pic)

  if Comix_ImagesEnabled then
-- Resetting Frames animation values --
    if Comix_Frames[ComixCurrentFrameCt]:IsVisible() then
      Comix_Frames[ComixCurrentFrameCt]:Hide()
    end  
    Comix_FramesStatus[ComixCurrentFrameCt] = 0
    Comix_FramesScale[ComixCurrentFrameCt] = 0.2
    Comix_FramesVisibleTime[ComixCurrentFrameCt] = 0 
   
-- Setting Texture --
    Comix_textures[ComixCurrentFrameCt]:SetTexture("Interface\\Addons\\Comix\\"..Pic);
    Comix_textures[ComixCurrentFrameCt]:SetAllPoints(Comix_Frames[ComixCurrentFrameCt]);
    Comix_Frames[ComixCurrentFrameCt].texture = Comix_textures[ComixCurrentFrameCt];
   
-- Positioning Frame --
     
    Comix_Frames[ComixCurrentFrameCt]:SetPoint("Center",x,y);
    Comix_Frames[ComixCurrentFrameCt]:Show();

-- Increasing Current Frame or resetting it to 1 --  
    if ComixCurrentFrameCt == 5 then
      ComixCurrentFrameCt = 1
    else
      ComixCurrentFrameCt = ComixCurrentFrameCt +1
    end
  end     
end  

function Comix_LoaddaShite()

-- Counting Normal Images --  
  ComixImagesCt = getn(ComixImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixImagesCt.." piccus",0,0,0)

-- Counting Images in Image-Sets --
  ComixFireImagesCt = getn(ComixFireImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixFireImagesCt.." piccus",0,0,1)

  ComixFrostImagesCt = getn(ComixFrostImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixFrostImagesCt.." piccus",0,1,1)

  ComixShadowImagesCt = getn(ComixShadowImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixShadowImagesCt.." piccus",0,1,0)

  ComixNatureImagesCt = getn(ComixNatureImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixNatureImagesCt.." piccus",1,1,0)

  ComixArcaneImagesCt = getn(ComixArcaneImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixArcaneImagesCt.." piccus",1,0,0)

  ComixHolyHealImagesCt = getn(ComixHolyHealImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixHolyHealImagesCt.." piccus",0,0,0)

  ComixHolyDmgImagesCt = getn(ComixHolyDmgImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixHolyDmgImagesCt.." piccus",0,0,0)
  
  ComixDeathImagesCt = getn(ComixDeathImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixDeathImagesCt.." piccus",0,0,0)

-- Counting Normal Sounds --
  ComixSoundsCt = getn(ComixSounds)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixSoundsCt.." sounds",1,0,1)
  
-- Counting Zone Sounds --
  ComixZoneSoundsCt = getn(ComixZoneSounds)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixZoneSoundsCt.." sounds",1,1,1)

-- Counting One hit Sounds --
  ComixOneHitSoundsCt = getn(ComixOneHitSounds)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixOneHitSoundsCt.." sounds",1,1,1)
  
-- Counting Healing Sounds --   
  ComixHealingSoundsCt = getn(ComixHealingSounds)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixHealingSoundsCt.." sounds",1,1,1)
  

-- Counting Specials --
  ComixSpecialCt = getn(ComixSpecialImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixSpecialCt.." specials",1,0,0)  
  
  -- Counting Ability Sounds --   
  ComixAbilitySoundsCt = getn(ComixAbilitySounds)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixAbilitySoundsCt.." sounds",1,1,1)

  -- Counting Death Sounds --   
  ComixDeathSoundsCt = getn(ComixDeathSounds)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixDeathSoundsCt.." sounds",1,1,1)
  
   -- Counting Ready check Sounds --   
  ComixReadySoundsCt = getn(ComixReadySounds)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixReadySoundsCt.." sounds",1,1,1)
  
  DEFAULT_CHAT_FRAME:AddMessage("Open options GUI with /comix or get Slashcommands with /comix help",0,0,1)
    
end

function Comix_Framehide()
 for i,line in ipairs(Comix_Frames) do
   Comix_Frames[i]:Hide();
   DEFAULT_CHAT_FRAME:AddMessage("Hiding Comix_Frames["..i.."]")
 end
end



function Comix_CallPic(Image)

  if Comix_ImagesEnabled then
-- Creating x,y Coordinates --
    Comix_x_coord = math.random(-120,120)
    if Comix_x_coord <= 0 then
      Comix_x_coord = Comix_x_coord -40
    else
      Comix_x_coord= Comix_x_coord +40
    end  
 
    if (abs(Comix_x_coord)<75) then
      local y_buffer = 50 
      Comix_y_coord = math.random(y_buffer,130)
    else
      Comix_y_coord = math.random(0,130)   
    end
  
-- Finally handing over x,y Coords and the image to show --
    Comix_CurrentImage = Image
    Comix_Pic(Comix_x_coord,Comix_y_coord,Image)
 end
 
end

function Comix_CreateFrames()
-- Creating 5 Frames, creating 5 Textures and setting FramesScale, FramesVisibleTime & FramesStatus--
  for i = 1,5 do
    -- Create Frame --
    Comix_Frames[i] = CreateFrame("Frame","ComixFrame"..i,UIParent)
    Comix_Frames[i]:SetWidth(128);
    Comix_Frames[i]:SetHeight(128);
    Comix_Frames[i]:Hide()
    -- Create texture for each frame --
    Comix_textures[i] = Comix_Frames[i]:CreateTexture(nil,"BACKGROUND")
    -- Setting FramesScale, FramesVisibleTime & FramesStatus  to 0 --
    Comix_FramesScale[i] = 0.2
    Comix_FramesVisibleTime[i] = 0
    Comix_FramesStatus[i] = 0
  end
  

  Comix_FrameFlash1Texture:SetVertexColor(1,0,0);
  Comix_FrameFlash2Texture:SetVertexColor(0,1,0);
  Comix_FrameFlash3Texture:SetVertexColor(1,0,0);
  Comix_FrameFlash4Texture:SetVertexColor(0,1,0);
end  

function Comix_DetermineDmgType(DmgLine)
  
  if  strfind(DmgLine, getglobal("COMIX_HEAL")) then
    if Comix_PlayerClass == COMIX_SHAMAN or COMIX_DRUID then
      Comix_HealorDmg = true
      return ComixHolyHealImages[math.random(1,ComixHolyHealImagesCt)]  
    elseif Comix_PlayerClass == COMIX_PALADIN then
      Comix_HealorDmg = true
      return ComixHolyHealImages[math.random(1,ComixHolyHealImagesCt)]    
    else 
      Comix_HealorDmg = true
      return ComixHolyHealImages[math.random(1,ComixHolyHealImagesCt)]
    end     

  elseif strfind(DmgLine, getglobal("COMIX_FIRE")) then
    Comix_HealorDmg = false
    return ComixFireImages[math.random(1,ComixFireImagesCt)]
       
  elseif  strfind(DmgLine, getglobal("COMIX_FROST")) then
    Comix_HealorDmg = false
    return ComixFrostImages[math.random(1,ComixFrostImagesCt)]
    
  elseif strfind(DmgLine, getglobal("COMIX_SHADOW")) then
    Comix_HealorDmg = false
    return ComixShadowImages[math.random(1,ComixShadowImagesCt)]

  elseif strfind(DmgLine, getglobal("COMIX_NATURE")) then
    Comix_HealorDmg = false
    return ComixNatureImages[math.random(1,ComixNatureImagesCt)]

  elseif strfind(DmgLine, getglobal("COMIX_ARCANE")) then
    Comix_HealorDmg = false
    return ComixArcaneImages[math.random(1,ComixArcaneImagesCt)]

  elseif strfind(DmgLine, getglobal("COMIX_HOLY")) then
    Comix_HealorDmg = false
    return ComixHolyDmgImages[math.random(1,ComixHolyDmgImagesCt)]

  else 
    Comix_HealorDmg = false
    return ComixImages[math.random(1,ComixImagesCt)]
  
  end
end