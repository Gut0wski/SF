<?php

namespace AppBundle\Controller;

use AppBundle\Entity\Discussions;
use AppBundle\Form\Message;
use AppBundle\Form\Subject;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\Security\Core\Authorization\AuthorizationCheckerInterface;
use Symfony\Component\HttpFoundation\Request;
use AppBundle\Form\Section;
use AppBundle\Extend\Utils\Paginate;

/**
 * Контроллер обсуждений
 * @package AppBundle\Controller
 */
class DiscussionsController extends Controller
{
    /**
     * @var array выводить ли скрытые элементы
     */
    private $hidden;

    /**
     * Конструктор
     * @param AuthorizationCheckerInterface $authorizationChecker
     */
    public function __construct(AuthorizationCheckerInterface $authorizationChecker)
    {
        $this->hidden = $authorizationChecker->isGranted('IS_AUTHENTICATED_FULLY') ? [] : ['hidden' => '0'];
    }

    /**
     * Вывод списка разделов
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function sectionsAction(Request $request)
    {
        $rows = $this->getDoctrine()
            ->getRepository("AppBundle:Discussions")
            ->findBy(array_merge(['type' => '1'], $this->hidden), ['dateCreate' => 'ASC']);
        $paginator = $this->get('knp_paginator');
        $list = $paginator->paginate(
            $rows,
            $request->query->getInt('page', 1),
            $request->query->getInt('limit', $this->container->getParameter('limit_blocks'))
        );
        return $this->render("@App/discussions/sections.html.twig", compact('list'));
    }

    /**
     * Создание раздела
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|\Symfony\Component\HttpFoundation\Response
     */
    public function newSectionAction(Request $request)
    {
        $section = new Discussions();
        $form = $this->createForm(Section::class, $section);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $section->setType(1);
            $section->setParent(null);
            $section->setUser($this->getUser()->getId());
            $em = $this->getDoctrine()->getManager();
            $em->persist($section);
            $em->flush();
            $page = Paginate::findPageModify(
                $section->getId(),
                $this->getDoctrine()
                    ->getRepository("AppBundle:Discussions")
                    ->findBy(array_merge(['type' => '1'], $this->hidden), ['dateCreate' => 'ASC']),
                $this->container->getParameter('limit_blocks')
            );
            return $this->redirectToRoute('sections', compact('page'));
        }
        return $this->render('@App/discussions/newSection.html.twig', [
            'form' => $form->createView(),
            'back' => $request->headers->get('referer')
        ]);
    }

    /**
     * Редактирование раздела
     * @param integer $id код раздела
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|\Symfony\Component\HttpFoundation\Response
     */
    public function editSectionAction($id, Request $request)
    {
        $section = $this->getDoctrine()
            ->getRepository("AppBundle:Discussions")
            ->findOneById($id);
        if (!$section) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $form = $this->createForm(Section::class, $section);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $section->setDateUpdate(new \DateTime());
            $em = $this->getDoctrine()->getManager();
            $em->persist($section);
            $em->flush();
            $page = Paginate::findPageModify(
                $section->getId(),
                $this->getDoctrine()
                    ->getRepository("AppBundle:Discussions")
                    ->findBy(array_merge(['type' => '1'], $this->hidden), ['dateCreate' => 'ASC']),
                $this->container->getParameter('limit_blocks')
            );
            return $this->redirectToRoute('sections', compact('page'));
        }
        return $this->render('@App/discussions/editSection.html.twig', [
            'form' => $form->createView(),
            'back' => $request->headers->get('referer')
        ]);
    }

    /**
     * Удаление раздела
     * @param integer $id код раздела
     * @return \Symfony\Component\HttpFoundation\RedirectResponse
     */
    public function deleteSectionAction($id)
    {
        $section = $this->getDoctrine()
            ->getRepository("AppBundle:Discussions")
            ->findOneById($id);
        if (!$section) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $pg = $this->getDoctrine()
            ->getRepository("AppBundle:Discussions")
            ->findBy(array_merge(['type' => '1'], $this->hidden), ['dateCreate' => 'ASC']);
        $em = $this->getDoctrine()->getManager();
        $em->remove($section);
        $em->flush();
        $page = Paginate::findPageDelete(
            $pg,
            $this->container->getParameter('limit_blocks')
        );
        return $this->redirectToRoute('sections', compact('page'));
    }

    /**
     * Вывод списка тем раздела
     * @param integer $section код раздела
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function subjectsAction($section, Request $request)
    {
        $rows = $this->getDoctrine()
            ->getRepository("AppBundle:Discussions")
            ->findBy(array_merge(['type' => '2', 'parent' => $section], $this->hidden), ['dateCreate' => 'ASC']);
        $paginator = $this->get('knp_paginator');
        $list = $paginator->paginate(
            $rows,
            $request->query->getInt('page', 1),
            $request->query->getInt('limit', $this->container->getParameter('limit_blocks'))
        );
        $link = $this->getDoctrine()
            ->getRepository("AppBundle:Discussions")
            ->findOneById($section)
            ->getTitle();
        foreach ($rows as $item) {
            $element = $this->getDoctrine()
                ->getRepository("AppBundle:Discussions")
                ->getSubjectMessages($item->getId());
            $details[$item->getId()]['count'] = count($element);
            $last = array_pop($element);
            $details[$item->getId()]['author'] = $last['username'];
            $details[$item->getId()]['create'] = $last['date_create'];
        }
        return $this->render("@App/discussions/subjects.html.twig", compact('section', 'link', 'list', 'details'));
    }

    /**
     * Создание темы
     * @param integer $section код раздела
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|\Symfony\Component\HttpFoundation\Response
     */
    public function newSubjectAction($section, Request $request)
    {
        $subject = new Discussions();
        $form = $this->createForm(Subject::class, $subject, compact('section'));
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $subject->setType(2);
            $subject->setUser($this->getUser()->getId());
            $em = $this->getDoctrine()->getManager();
            $em->persist($subject);
            $em->flush();
            $page = Paginate::findPageModify(
                $subject->getId(),
                $this->getDoctrine()
                    ->getRepository("AppBundle:Discussions")
                    ->findBy(array_merge(['type' => '2', 'parent' => $section], $this->hidden), ['dateCreate' => 'ASC']),
                $this->container->getParameter('limit_blocks')
            );
            return $this->redirectToRoute('subjects', [
                'section' => $form->get('parent')->getData()->getId(),
                'page' => $page
            ]);
        }
        return $this->render('@App/discussions/newSubject.html.twig', [
            'form' => $form->createView(),
            'back' => $request->headers->get('referer')
        ]);
    }

    /**
     * Редактирование темы
     * @param integer $id код темы
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|\Symfony\Component\HttpFoundation\Response
     */
    public function editSubjectAction($id, Request $request)
    {
        $subject = $this->getDoctrine()
            ->getRepository("AppBundle:Discussions")
            ->findOneById($id);
        if (!$subject) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $form = $this->createForm(Subject::class, $subject);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $subject->setDateUpdate(new \DateTime());
            $em = $this->getDoctrine()->getManager();
            $em->persist($subject);
            $em->flush();
            $section = $form->get('parent')->getData()->getId();
            $page = Paginate::findPageModify(
                $subject->getId(),
                $this->getDoctrine()
                    ->getRepository("AppBundle:Discussions")
                    ->findBy(array_merge(['type' => '2', 'parent' => $section], $this->hidden), ['dateCreate' => 'ASC']),
                $this->container->getParameter('limit_blocks')
            );
            return $this->redirectToRoute('subjects', compact('section', 'page'));
        }
        return $this->render('@App/discussions/editSubject.html.twig', [
            'form' => $form->createView(),
            'back' => $request->headers->get('referer')
        ]);
    }

    /**
     * Удаление темы
     * @param integer $id код темы
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\RedirectResponse
     */
    public function deleteSubjectAction($id, Request $request)
    {
        $subject = $this->getDoctrine()
            ->getRepository("AppBundle:Discussions")
            ->findOneById($id);
        if (!$subject) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $section = $subject->getParent()->getId();
        $pg = $this->getDoctrine()
            ->getRepository("AppBundle:Discussions")
            ->findBy(array_merge(['type' => '2', 'parent' => $section], $this->hidden), ['dateCreate' => 'ASC']);
        $em = $this->getDoctrine()->getManager();
        $em->remove($subject);
        $em->flush();
        $page = Paginate::findPageDelete(
            $pg,
            $this->container->getParameter('limit_blocks')
        );
        return $this->redirectToRoute('subjects', compact('section', 'page'));
    }

    /**
     * Вывод списка сообщений темы
     * @param integer $subject код темы
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function messagesAction($subject, Request $request)
    {
        $user_id = (!empty($this->getUser())) ? $this->getUser()->getId() : null;
        //форма
        $message = new Discussions();
        $form = $this->createForm(Message::class, $message);
        $form->get('parent')->setData($subject);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $parent = $form->get('parent')->getData();
            // редактировать сообщение
            if ($parent < 0) {
                $edit = $this->getDoctrine()
                    ->getRepository("AppBundle:Discussions")
                    ->findOneById(abs($parent));
                $edit->setText($form->get('text')->getData());
                $edit->setDateUpdate(new \DateTime());
                $em = $this->getDoctrine()->getManager();
                $em->persist($edit);
                $em->flush();
                $id = $edit->getId();
            // создать сообщение
            } else {
                $message->setType(3);
                $object_parent = $this->getDoctrine()
                    ->getRepository("AppBundle:Discussions")
                    ->findOneById($parent);
                $message->setParent($object_parent);
                $message->setUser($user_id);
                $em = $this->getDoctrine()->getManager();
                $em->persist($message);
                $em->flush();
                $id = $message->getId();
            }
            $page = Paginate::findPageModify2(
                $id,
                $this->getDoctrine()
                    ->getRepository("AppBundle:Discussions")
                    ->getSubjectMessages($subject),
                $this->container->getParameter('limit_blocks')
            );
            return $this->redirectToRoute('messages', compact('subject', 'page'));
        }
        // сообщения раздела
        $rows = $this->getDoctrine()
            ->getManager()
            ->getRepository("AppBundle:Discussions")
            ->getSubjectMessages($subject);
        $paginator = $this->get('knp_paginator');
        $list = $paginator->paginate(
            $rows,
            $request->query->getInt('page', 1),
            $request->query->getInt('limit', $this->container->getParameter('limit_blocks'))
        );
        // блокирован ли пользователь
        if (!empty($user_id)) {
            $block = $this->getDoctrine()
                ->getManager()
                ->getRepository("AppBundle:Blocks")
                ->getActiveBlockUser($user_id);
        }
        // тема
        $object_subject = $this->getDoctrine()
            ->getRepository("AppBundle:Discussions")
            ->findOneById($subject);
        // раздел
        $object_section = $this->getDoctrine()
            ->getRepository("AppBundle:Discussions")
            ->findOneById($object_subject->getParent());
        return $this->render("@App/discussions/messages.html.twig", [
            'block' => $block,
            'subject' => $subject,
            'link' => [
                'id' => $object_section->getId(),
                'title' => $object_section->getTitle()
            ],
            'title' => $object_subject->getTitle(),
            'list' => $list,
            'form' => $form->createView()
        ]);
    }

    /**
     * Удаление сообщения
     * @param integer $id код сообщения
     * @param integer $subject код темы
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\RedirectResponse
     */
    public function deleteMessageAction($id, $subject, Request $request)
    {
        $message = $this->getDoctrine()
            ->getRepository("AppBundle:Discussions")
            ->findOneById($id);
        if (!$message) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $pg = $this->getDoctrine()
            ->getRepository("AppBundle:Discussions")
            ->getSubjectMessages($subject);
        $em = $this->getDoctrine()->getManager();
        $em->remove($message);
        $em->flush();
        $page = Paginate::findPageDelete2(
            $id,
            $pg,
            $this->container->getParameter('limit_blocks')
        );
        return $this->redirectToRoute('messages', compact('subject', 'page'));
    }
}