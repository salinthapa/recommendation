<?php

use Illuminate\Http\Request;
use Modules\User\Http\Controllers\SessionController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::group(["as" => "admin."], function () {
    Route::post("register", [Modules\User\Http\Controllers\UserController::class, "register"])->name('users.register');
    Route::post("login", [SessionController::class, "login"])->name("login");
    Route::group(["middleware" => "auth:api"], function () {
        Route::put("users/{user}/update-status", [Modules\User\Http\Controllers\UserController::class, "updateStatus"])->name('users.update-status');
        Route::resource("users", UserController::class);
        Route::get("me", [SessionController::class, "me"])->name("me");
        Route::get("logout", [SessionController::class, "logout"])->name("logout");
    });
});


