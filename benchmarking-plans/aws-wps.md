# AWS-WPS Benchmarking Plan
We have a dev profile for aws-wps (in the vars dir), which will be accesible at https://pixeldrill-wps.dev.aodn.org.au/wps.

1. Send a POST request to https://pixeldrill-wps.dev.aodn.org.au/wps with the following raw input, altering the time and location in line 18 appropriately
```xml
<wps:Execute version="1.0.0" service="WPS" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.opengis.net/wps/1.0.0" xmlns:wfs="http://www.opengis.net/wfs" xmlns:wps="http://www.opengis.net/wps/1.0.0" xmlns:ows="http://www.opengis.net/ows/1.1" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc" xmlns:wcs="http://www.opengis.net/wcs/1.1.1" xmlns:xlink="http://www.w3.org/1999/xlink" xsi:schemaLocation="http://www.opengis.net/wps/1.0.0 http://schemas.opengis.net/wps/1.0.0/wpsAll.xsd">
    <ows:Identifier>gs:GoGoDuck</ows:Identifier>
    <wps:DataInputs>
        <wps:Input>
            <ows:Identifier>layer</ows:Identifier>
            <wps:Data>
                <wps:LiteralData>srs_ghrsst_l3s_1d_ngt_url</wps:LiteralData>
            </wps:Data>
        </wps:Input>
        <wps:Input>
            <ows:Identifier>subset</ows:Identifier>
            <wps:Data>
                <wps:LiteralData>TIME,2021-07-25T15:20:00.000Z,2021-07-25T15:20:00.000Z;LATITUDE,-20.88,-20.88;LONGITUDE,111.45,111.45</wps:LiteralData>
            </wps:Data>
        </wps:Input>
    </wps:DataInputs>
    <wps:ResponseForm>
        <wps:ResponseDocument storeExecuteResponse="true" status="true">
            <wps:Output asReference="true" mimeType="application/x-netcdf">
                <ows:Identifier>result</ows:Identifier>
            </wps:Output>
        </wps:ResponseDocument>
    </wps:ResponseForm>
</wps:Execute>
```

2. Open https://pixeldrill-wps.dev.aodn.org.au/wps/jobStatus?format=queue in a browser to see the current job history
2. When the job is finished, click the "log" link
2. In the "filte revents" search bar, type "Commencing download" and note the time of the message result
2. In the "filte revents" search bar, type  "Raw aggregated file size" and note the time of the message result
2. Calculate the time difference
