<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('otp_codes', function (Blueprint $table) {
            $table->increments('id'); // INT AUTO_INCREMENT PRIMARY KEY
            $table->string('email', 255);
            $table->string('otp', 10);
            $table->dateTime('expires_at');
            $table->timestamp('created_at')->useCurrent();

            $table->index('email');
            $table->index(['email', 'otp']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('otp_codes');
    }
};
