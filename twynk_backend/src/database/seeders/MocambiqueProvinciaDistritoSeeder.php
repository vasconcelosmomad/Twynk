<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;
use App\Models\Pais;

class MocambiqueProvinciaDistritoSeeder extends Seeder
{
    public function run(): void
    {
        DB::statement('SET FOREIGN_KEY_CHECKS=0;');

        // Garante que o país Moçambique exista e obtém o seu ID real
        $pais = Pais::firstOrCreate(
            ['nome' => 'Moçambique'],
            ['status' => 'ativo']
        );

        // Limpa distritos e províncias apenas deste país
        DB::table('distrito')->truncate();
        DB::table('provincia')->where('pais_id', $pais->id)->delete();

        DB::statement('SET FOREIGN_KEY_CHECKS=1;');

        $now = Carbon::now(); // mantido caso queira usar no futuro, mas não gravamos timestamps

        // ========================
        // PROVÍNCIAS + DISTRITOS
        // ========================
        $dados = [
            'Maputo Cidade' => [
                'KaMpfumo',
                'Nhlamankulo',
                'KaMaxaquene',
                'KaMubukwana',
                'KaMavota',
                'KaTembe',
            ],

            'Maputo Província' => [
                'Boane',
                'Magude',
                'Manhiça',
                'Marracuene',
                'Moamba',
                'Namaacha',
                'Matola',
            ],

            'Gaza' => [
                'Chibuto',
                'Chicualacuala',
                'Chigubo',
                'Chókwè',
                'Guijá',
                'Mabalane',
                'Mandlakazi',
                'Massagena',
                'Xai-Xai',
            ],

            'Inhambane' => [
                'Funhalouro',
                'Govuro',
                'Homoíne',
                'Inharrime',
                'Inhassoro',
                'Jangamo',
                'Massinga',
                'Morrumbene',
                'Vilankulo',
                'Maxixe',
            ],

            'Sofala' => [
                'Búzi',
                'Caia',
                'Cheringoma',
                'Chibabava',
                'Dondo',
                'Gorongosa',
                'Marromeu',
                'Muanza',
                'Nhamatanda',
                'Beira',
            ],

            'Manica' => [
                'Báruè',
                'Chimoio',
                'Gondola',
                'Macate',
                'Machaze',
                'Macossa',
                'Mossurize',
                'Sussundenga',
                'Tambara',
                'Vanduzi',
            ],

            'Tete' => [
                'Angónia',
                'Cahora-Bassa',
                'Changara',
                'Chiuta',
                'Macanga',
                'Marávia',
                'Moatize',
                'Mutarara',
                'Tete',
                'Tsangano',
                'Zumbo',
                'Doa',
            ],

            'Zambézia' => [
                'Alto Molócuè',
                'Chinde',
                'Gilé',
                'Gurué',
                'Ile',
                'Inhassunge',
                'Lugela',
                'Maganja da Costa',
                'Milange',
                'Mocuba',
                'Mopeia',
                'Morrumbala',
                'Namacurra',
                'Namarroi',
                'Nicoadala',
                'Pebane',
                'Quelimane',
            ],

            'Nampula' => [
                'Angoche',
                'Eráti',
                'Lalaua',
                'Malema',
                'Mecubúri',
                'Memba',
                'Mogovolas',
                'Moma',
                'Monapo',
                'Mossuril',
                'Nacala-a-Velha',
                'Nampula',
                'Ribáuè',
                'Nacala',
                'Nanhupo',
                'Ilha de Moçambique',
            ],

            'Cabo Delgado' => [
                'Ancuabe',
                'Balama',
                'Chiúre',
                'Ibo',
                'Macomia',
                'Mecúfi',
                'Meluco',
                'Mocímboa da Praia',
                'Montepuez',
                'Mueda',
                'Namuno',
                'Nangade',
                'Palma',
                'Pemba',
                'Quissanga',
            ],

            'Niassa' => [
                'Cuamba',
                'Lago',
                'Lichinga',
                'Majune',
                'Mandimba',
                'Marrupa',
                'Maúa',
                'Mavago',
                'Mecanhelas',
                'Mecula',
                'Metarica',
                'Muembe',
                'N\'gauma',
                'Sanga',
            ],
        ];

        // ========================
        // INSERT PROVÍNCIAS + DISTRITOS
        // ========================
        foreach ($dados as $provinciaNome => $distritos) {

            $provinciaId = DB::table('provincia')->insertGetId([
                'nome'    => $provinciaNome,
                'pais_id' => $pais->id,
            ]);

            foreach ($distritos as $distrito) {
                DB::table('distrito')->insert([
                    'nome'         => $distrito,
                    'provincia_id' => $provinciaId,
                ]);
            }
        }
    }
}
