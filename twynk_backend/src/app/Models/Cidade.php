<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Cidade extends Model
{
    use HasFactory;

    protected $table = 'cidade';

    protected $fillable = [
        'nome',
        'provincia_id',
    ];

    public $timestamps = false;

    /**
     * Get the provincia that owns the cidade.
     */
    public function provincia(): BelongsTo
    {
        return $this->belongsTo(Provincia::class, 'provincia_id');
    }
}
