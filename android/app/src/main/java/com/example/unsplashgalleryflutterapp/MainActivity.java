package com.example.unsplashgalleryflutterapp;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;

import java.io.File;
import java.io.FileOutputStream;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.reactivex.Observable;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.schedulers.Schedulers;

public class MainActivity extends FlutterActivity {
    private final String CHANNEL = "unsplash_gallery_flutter_app/save_image";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler((methodCall, result) -> {
            if (methodCall.method.equals("saveImage")) {
                final byte[] img = methodCall.argument("imgBytes");
                final String dirName = methodCall.argument("directoryName");
                final String imgName = methodCall.argument("fileName");

                Observable.fromCallable(() -> saveImageAsync(img, imgName, dirName))
                        .subscribeOn(Schedulers.newThread())
                        .observeOn(AndroidSchedulers.mainThread())
                        .doOnNext(isSaved -> {
                            if (isSaved) result.success("Image " + imgName.trim() + ".jpg saved!");
                            else result.success("Something go wrong during saving process!");
                        })
                        .doOnError(throwable -> result.success(throwable.getMessage()))
                        .subscribe();

            } else {
                result.notImplemented();
            }
        });
    }

    private boolean saveImageAsync(byte[] image, String imageName, String directoryName) {
        File myDir = new File(Environment.getExternalStorageDirectory().toString() + "/" + directoryName);
        if (!myDir.exists()) {
            myDir.mkdirs();
            sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.fromFile(myDir)));
        }

        File file = new File(myDir, imageName.trim() + ".jpg");
        if (file.exists()) file.delete();

        try {
            FileOutputStream out = new FileOutputStream(file);
            out.write(image);
            out.flush();
            out.close();
            sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.fromFile(file)));
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
