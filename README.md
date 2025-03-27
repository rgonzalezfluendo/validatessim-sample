# validatessim sample


[Documentation](https://gitlab.freedesktop.org/gstreamer/gstreamer/-/blob/main/subprojects/gst-devtools/docs/plugins/ssim.md)

## Examples

### Example from documentation

```
rm -rf /tmp/test && mkdir -p /tmp/test
GST_VALIDATE_CONFIG=check_agingtv_ssim.config gst-validate-1.0 uridecodebin uri=https://media.w3.org/2010/05/sintel/trailer.mp4 ! videoconvert ! agingtv name=my_agingtv ! videoconvert ! autovideosink
```

### Example with a encoder and decorder


* with `min-avg-priority=0.95` (default): ✓
```
rm -rf /tmp/test && mkdir -p /tmp/test
GST_VALIDATE_CONFIG=check_dec_ssim.config gst-validate-1.0 gltestsrc pattern=mandelbrot  num-buffers=400 ! glcolorconvert ! gldownload ! video/x-raw,width=1280,height=720,framerate=30/1,format=I420 ! queue name=iraw ! mpeg2enc ! mpeg2dec name=dec ! videoconvert ! xvimagesink
```



* with `min-avg-priority=0.999`: ✗
```
rm -rf /tmp/test && mkdir -p /tmp/test
GST_VALIDATE_CONFIG=check_dec_999_ssim.config gst-validate-1.0 gltestsrc pattern=mandelbrot  num-buffers=400 ! glcolorconvert ! gldownload ! video/x-raw,width=1280,height=720,framerate=30/1,format=I420 ! queue name=iraw ! mpeg2enc ! mpeg2dec name=dec ! videoconvert ! xvimagesink
```


Error:
```
ssim-override-/GstPipeline:pipeline0/GstMpeg2dec:dec.GstPad:src --> Running frame comparison between images from '/tmp/test/before-dec/' and '/tmp/test/after-dec/' . Issues can be visialized in /tmp/test/failures.


**Got criticals. Return value set to 18**:
  * critical error Average similarity '0.975167' between /tmp/test/before-dec/0-00-00.000000000.1280x720.I420 and /tmp/test/after-dec/0-00-00.000000000.1280x720.I420 inferior than the minimum average: 0.999000 (See /tmp/test/failures/original_0-00-00.000000000.1280x720.I420.VS.nok_0-00-00.000000000.1280x720.I420.result.png to check differences in images)

Bail out! Fatal report received: 0:00:06.117994505 <gst-validate-images-checker>: 2551 (critical) : ssim: Compared images were not similar enough: Average similarity '0.975167' between /tmp/test/before-dec/0-00-00.000000000.1280x720.I420 and /tmp/test/after-dec/0-00-00.000000000.1280x720.I420 inferior than the minimum average: 0.999000 (See /tmp/test/failures/original_0-00-00.000000000.1280x720.I420.VS.nok_0-00-00.000000000.1280x720.I420.result.png to check differences in images)
     issue : EOS events that are part of the same pipeline 'operation' should have the same seqnum
             Detected on <mpeg2enc0:src, dec:sink, dec:src, fakesink0:sink>
             Description : when events/messages are created from another event/message, they should have their seqnums set to the original event/message seqnum

  critical : Compared images were not similar enough
             Detected on <gst-validate-images-checker>
             Details : Average similarity '0.975167' between /tmp/test/before-dec/0-00-00.000000000.1280x720.I420 and /tmp/test/after-dec/0-00-00.000000000.1280x720.I420 inferior than the minimum average: 0.999000 (See /tmp/test/failures/original_0-00-00.000000000.1280x720.I420.VS.nok_0-00-00.000000000.1280x720.I420.result.png to check differences in images)
             Description : The images checker detected that the images it is comparing do not have the similarity level defined with min-avg-similarity or min-lowest-similarity

Issues found: 2
```

![first_failure](original_0-00-00.000000000.1280x720.I420.VS.nok_0-00-00.000000000.1280x720.I420.result.png)  



## Docker


```
docker build . -t arch_gst_validate
rm -rf test && mkdir -p test
docker run --privileged -e GST_VALIDATE_CONFIG=/ws/check_dec_999_ssim.config  -v ./test:/tmp/test -v $PWD:/ws arch_gst_validate  gst-validate-1.0 gltestsrc pattern=mandelbrot  num-buffers=400 ! glcolorconvert ! gldownload ! video/x-raw,width=1280,height=720,framerate=30/1,format=I420 ! queue name=iraw ! mpeg2enc ! mpeg2dec name=dec ! fakesink
```
