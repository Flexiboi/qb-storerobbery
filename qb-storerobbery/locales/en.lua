local Translations = {
    error = {
        minimum_store_robbery_police = "Not enough police (Needed %{MinimumStoreRobberyPolice})",
        vehicle_driver = "Rip, you cant drive while holding the register..",
        process_canceled = "Stopped..",
        you_broke_the_lock_pick = "Lockpick has broken",
        missingstealitem = 'You need: ',
        alreadystealing = 'You are already stealing something..',
        failedsafe = 'You didnt manage to open the register..',
    },
    success = {
        checkgps = 'Check your GPS for the location',
        deliveredreg = 'Register has been delivered!',
    },
    text = {
        the_cash_register_is_empty = "Register is empty..",
        the_cash_register_is_stolen = "Register has been stolen..",
        try_combination = "~g~E~w~ - Try combination",
        safe_opened = "Register has been opened..",
        emptying_the_register= "Stealing from register..",
        steal_the_register= "Taking register..",
        safe_code = "Safecode: ",
        stealreg = 'Steal register',
        dropreg = ' to drop the register',
        pickreg = ' to take the register',
        deliverreg = ' to deliver the register',
    },
    email = {
        shop_robbery = "10-31 | Shoprobbery",
        someone_is_trying_to_rob_a_store = "There is someone at %{street} (CAMERA ID: %{cameraId1}) stealing stuff",
        storerobbery_progress = "Shoprobbery"
    },
    menu = {
        header = 'Cut the right cable',
        redwire = 'Red cable',
        bluewire = 'Blue cable',
        back = 'Go back',
    },
    blip = {
        blipname = 'Dropoff'
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
