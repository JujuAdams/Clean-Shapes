function CleanBatchStart()
{
    if (is_array(global.__cleanBatch))
    {
        __CleanError("Cannot start a batch when a batch has already been started");
        exit;
    }
    
    global.__cleanBatch = [];
}