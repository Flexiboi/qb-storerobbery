local Translations = {
    error = {
        minimum_store_robbery_police = "ni genoeg politie (%{MinimumStoreRobberyPolice} nodig)",
        vehicle_driver = "Da ga moeilijk rijden zijn me een kassa in je handen..",
        process_canceled = "Gestopt..",
        you_broke_the_lock_pick = "Lockpick is kapot gegaan",
        missingstealitem = 'Je mist: ',
        alreadystealing = 'Je bent al aan het stelen makker..',
        failedsafe = 'Het lukte je niet de kluis te openen..',
    },
    success = {
        checkgps = 'Check je gps voor de leverlocatie',
        deliveredreg = 'Kassa met succes afgeleverd!',
    },
    text = {
        the_cash_register_is_empty = "Kassa is leeg..",
        the_cash_register_is_stolen = "Kassa is gestolen..",
        try_combination = "~g~E~w~ - Probeer combinatie",
        safe_opened = "Kluis is al geopend..",
        emptying_the_register= "Kassa leegroven..",
        steal_the_register= "Kassa pikken..",
        safe_code = "Kluiscode: ",
        stealreg = 'Steel de kassa',
        dropreg = ' om de kassa te droppen',
        pickreg = ' om de kassa op te pakken',
        deliverreg = ' om de kassa af te geven',
    },
    email = {
        shop_robbery = "10-31 | Winekloverval",
        someone_is_trying_to_rob_a_store = "Der is iemand ne winkel aant overvallen dichtbij %{street} (CAMERA ID: %{cameraId1})",
        storerobbery_progress = "Winkeloverval"
    },
    menu = {
        header = 'Knip de juiste draad door',
        redwire = 'Rode draad',
        bluewire = 'Blauwe draad',
        back = 'Ga terug',
    },
    blip = {
        blipname = 'Leverlocatie'
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
