<?php

namespace AppBundle\Controller;

use AppBundle\Form\EditDocument;
use AppBundle\Form\NewDocument;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use AppBundle\Entity\Documents;
use Symfony\Component\Filesystem\Filesystem;
use AppBundle\Extend\Utils\Paginate;

/**
 * Контроллер документов
 * @package AppBundle\Controller
 */
class DocumentsController extends Controller
{
    /**
     * Вывод списка документов
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function listAction(Request $request)
    {
        $rows = $this->getDoctrine()
            ->getRepository("AppBundle:Documents")
            ->findBy(array(), ['date' => 'DESC']);
        $paginator = $this->get('knp_paginator');
        $list = $paginator->paginate(
            $rows,
            $request->query->getInt('page', 1),
            $request->query->getInt('limit', $this->container->getParameter('limit_blocks'))
        );
        return $this->render("@App/documents/list.html.twig", compact('list'));
    }

    /**
     * Создание документа
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|\Symfony\Component\HttpFoundation\Response
     */
    public function newAction(Request $request)
    {
        $item = new Documents();
        $form = $this->createForm(NewDocument::class, $item);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $file = $item->getFile();
            $fileName = md5(uniqid()) . '.' . $file->guessExtension();
            $file->move(
                $this->getParameter('files_directory'),
                $fileName
            );
            $item->setFile($fileName);
            $em = $this->getDoctrine()->getManager();
            $em->persist($item);
            $em->flush();
            $page = Paginate::findPageModify(
                $item->getId(),
                $this->getDoctrine()
                    ->getRepository("AppBundle:Documents")
                    ->findBy(array(), ['date' => 'DESC']),
                $this->container->getParameter('limit_blocks')
            );
            return $this->redirectToRoute('documents', compact('page'));



        }
        return $this->render('@App/documents/new.html.twig', [
            'form' => $form->createView(),
            'back' => $request->headers->get('referer')
        ]);
    }

    /**
     * Редактирование документа
     * @param integer $id код документа
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function editAction($id, Request $request)
    {
        $item = $this->getDoctrine()
            ->getRepository("AppBundle:Documents")
            ->find($id);
        if (!$item) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $fileName = $item->getFile();
        $form = $this->createForm(EditDocument::class, $item);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            if (!empty($form->get('file')->getData())) {
                $filesystem = new Filesystem();
                $filesystem->remove($this->getParameter('files_directory') . '/'. $fileName);
                $file = $item->getFile();
                $fileName = md5(uniqid()) . '.' . $file->guessExtension();
                $file->move(
                    $this->getParameter('files_directory'),
                    $fileName
                );
            }
            $item->setFile($fileName);
            $em = $this->getDoctrine()->getManager();
            $em->persist($item);
            $em->flush();
            $page = Paginate::findPageModify(
                $item->getId(),
                $this->getDoctrine()
                    ->getRepository("AppBundle:Documents")
                    ->findBy(array(), ['date' => 'DESC']),
                $this->container->getParameter('limit_blocks')
            );
            return $this->redirectToRoute('documents', compact('page'));
        }
        return $this->render('@App/documents/edit.html.twig', [
            'form' => $form->createView(),
            'back' => $request->headers->get('referer')
        ]);
    }

    /**
     * Удаление документа
     * @param integer $id код документа
     * @return \Symfony\Component\HttpFoundation\RedirectResponse
     */
    public function deleteAction($id)
    {
        $item = $this->getDoctrine()
            ->getRepository("AppBundle:Documents")
            ->find($id);
        if (!$item) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $pg = $this->getDoctrine()
            ->getRepository("AppBundle:Documents")
            ->findBy(array(), ['date' => 'DESC']);
        $filename = $this->getParameter('files_directory') . '/'. $item->getFile();
        $filesystem = new Filesystem();
        $filesystem->remove($filename);
        $em = $this->getDoctrine()->getManager();
        $em->remove($item);
        $em->flush();
        $page = Paginate::findPageDelete(
            $pg,
            $this->container->getParameter('limit_blocks')
        );
        return $this->redirectToRoute('documents', compact('page'));
    }
}