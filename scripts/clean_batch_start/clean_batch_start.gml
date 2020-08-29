function clean_batch_start()
{
    if (is_array(global.__clean_batch))
    {
        __clean_error("Cannot start a batch when a batch has already been started");
        exit;
    }
    
    global.__clean_batch = [];
}