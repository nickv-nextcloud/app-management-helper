<?php

declare(strict_types=1);
/**
 * SPDX-FileCopyrightText: 2024 Joas Schilling <coding@schilljs.com>
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */

$content = file_get_contents($argv[1] . '/appinfo/info.xml');
$serverVersion = $argv[2];
$xml = simplexml_load_string($content);

$bumpedMinVersion = false;
if (isset($xml->dependencies?->nextcloud?->attributes()['min-version'])) {
	$minServer = (int) $xml->dependencies?->nextcloud?->attributes()['min-version'];
	if ($minServer === ($serverVersion - 1)) {
		$content = str_replace('nextcloud min-version="' . $minServer . '"', 'nextcloud min-version="' . $serverVersion . '"', $content);
		$bumpedMinVersion = true;
	}
}

if (isset($xml->dependencies?->nextcloud?->attributes()['max-version'])) {
	$maxServer = (int) $xml->dependencies?->nextcloud?->attributes()['max-version'];
	if ($maxServer === ($serverVersion - 1)) {
		$content = str_replace('" max-version="' . $maxServer . '"', '" max-version="' . $serverVersion . '"', $content);
	}
}

$appVersion = (string) $xml->version;

$versions = explode('.', $appVersion, 3);

if ($bumpedMinVersion) {
	$versions[0]++;
	$versions[1] = '0';
} else {
	$versions[1]++;
}
$versions[2] = '0-dev.0';

$newVersion = implode('.', $versions);
$content = str_replace('<version>' . $appVersion . '</version>', '<version>' . $newVersion . '</version>', $content);

file_put_contents($argv[1] . '/appinfo/info.xml', $content);

