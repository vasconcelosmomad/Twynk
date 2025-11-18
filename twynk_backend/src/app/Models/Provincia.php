<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Provincia extends Model
{
    use HasFactory;

    protected $table = 'provincia';

    protected $fillable = [
        'nome',
        'pais_id',
    ];

    public $timestamps = false;

    /**
     * Get the pais that owns the provincia.
     */
    public function pais(): BelongsTo
    {
        return $this->belongsTo(Pais::class, 'pais_id');
    }

    /**
     * Get the cidades for the provincia.
     */
    public function cidades(): HasMany
    {
        return $this->hasMany(Cidade::class, 'provincia_id');
    }
}
