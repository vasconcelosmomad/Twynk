<?php

namespace App\Models;

use App\Services\B2Service;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Media extends Model
{
    use HasFactory;

    protected $table = 'media';

    protected $fillable = [
        'user_uid',
        'type',
        'filename',
        'path',
        'size',
    ];

    protected $casts = [
        'size' => 'integer',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    protected static function booted()
    {
        static::deleting(function ($media) {
            app(B2Service::class)->delete($media->path);
        });
    }
}
