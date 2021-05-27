# Image picker Features

* Features
    * Firebase upload the file, replace the file.

* Input
    * Where to upload.
        * Filepath
            * storage_bucket (default for now)
            * folder_path
            * file_name
                * if file_name is given from parent component, it will be 
                  used, otherwise we will use uuid+filename from disk. 
    * inputs
        * folder_path
        * function to run when a new file is uploaded.
            * place the generated url to cubit.
* Output
    * 
* View
    * Before image is selected
        * Placeholder image, 
        * Edit icon
        * Click to upload.
    * After image is selected
        * Image
        * Edit icon
    * Will take all available space from the parent.
*   
