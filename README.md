# pixeldrill
Temporary repository used for work on pixeldrill project. For ease of development this repository has been made public, however it is for internal use only.

# Notebook Usage
The notebook can be accessed on the AWS console via the address https://ap-southeast-2.console.aws.amazon.com/sagemaker/home?region=ap-southeast-2#/notebook-instances/pixeldrill-notebook

You will need to be an administrator on nonproduction account, following [the aws authenitcation guide](https://github.com/aodn/internal-discussions/wiki/AWS-authentication-guide)

## S3 Bucket
A temporary s3 bucket has been created with the name "imos-data-pixeldrill". It can be accessed at http://imos-data-pixeldrill.s3-website-ap-southeast-2.amazonaws.com/. It contains copies of one set of gridded data which we can benchmark on. Data can be-copied by devs using the following command:
```AWS_PROFILE=nonproduction-admin aws s3 cp s3://imos-data/IMOS/SRS/SST/ghrsst/L3S-1d/ngt/ s3://imos-data-pixeldrill/IMOS/SRS/SST/ghrsst/L3S-1d/ngt/ --recursive --copy-props none```

