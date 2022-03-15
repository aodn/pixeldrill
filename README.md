Pixel Drill
=
Pixel Drill is an investigation into methods for efficient extraction of long time-series from IMOS satellite gridded products. This is work towards a Q4 milestone in the 2020-21 AODN Implementation Plan.

`
Develop prototype to more efficiently extract long time-series from IMOS satellite gridded products (e.g. investigate new tools or data structure such as Pangeo and ERRDAP and their integration with AODN infrastructure on AWS for a selected number of gridded dataset collections).
`

This repository is temporary for the purpose of work on pixeldrill project. For ease of development this repository has been made public, however it is for internal use only.

# Notebook Usage
The notebook can be accessed on the AWS console via the address https://ap-southeast-2.console.aws.amazon.com/sagemaker/home?region=ap-southeast-2#/notebook-instances/pixeldrill-notebook 
You will need to be an administrator on nonproduction account, following [the aws authenitcation guide](https://github.com/aodn/internal-discussions/wiki/AWS-authentication-guide)
It will turn off after 2 hours of disuse. Click "Start" to restart it and then "Open JupyterLab" to get into the notebook itself. Use the conda_mxnet_latest_p37 python environment, which will have all the libraries from requirements.txt installed by default.

## S3 Bucket
A temporary s3 bucket has been created with the name "imos-data-pixeldrill". It can be accessed at http://imos-data-pixeldrill.s3-website-ap-southeast-2.amazonaws.com/. It contains copies of one set of gridded data which we can benchmark on. Data can be-copied by devs using the following command:
```AWS_PROFILE=nonproduction-admin aws s3 cp s3://imos-data/IMOS/SRS/SST/ghrsst/L3S-1d/ngt/ s3://imos-data-pixeldrill/IMOS/SRS/SST/ghrsst/L3S-1d/ngt/ --recursive --copy-props none```

## Access Examples
The following example python scripts will load data for the years 2010 and 2011 which can be accessed using standard xarray functions. The index method is very slow, so you will need to set-up clustering to work with longer time periods.

### Zarr Files Access
``` Python
import xarray as xr
references = [f's3://imos-data-pixeldrill/zarrs/{year}/'for year in range(2010, 2012)]
zarrs = [xr.open_zarr(r) for r in references]
data = xr.concat(zarrs,dim='time',coords='minimal',compat='override',combine_attrs='override', fill_value='')
```

### Index Access
``` Python
import xarray as xr
import fsspec
import glob

fs = fsspec.filesystem('s3',anon=True)
references = fs.glob(f'imos-data-pixeldrill/refs/2010*')
references += fs.glob(f'imos-data-pixeldrill/refs/2011*')

def open_zarr(r):
    m = fsspec.get_mapper("reference://", 
                              remote_protocol='s3',
                    fo=f's3://{r}', remote_options={'anon':True,'skip_instance_cache':True,'use_listings_cache':False})
    ds = xr.open_zarr(m, consolidated=False)
    return ds

zarrs = [open_zarr(r) for r in references]
zarrs = [z.drop_vars(['sea_ice_fraction', 'sea_ice_fraction_dtime_from_sst'], errors='ignore') for z in zarrs]
data = xr.concat(zarrs,dim='time',coords='minimal',compat='override',combine_attrs='override', fill_value='')
```
